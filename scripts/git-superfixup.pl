#!/usr/bin/perl
# Scan unstaged changes in git tracked files, identify which commits they could
# be applied to as fixups, and automatically produce the appropriate "fixup!"
# commits for use with "git rebase -i --autosquash".
#
# Copyright (C) 2016, 2017 by Mat Sutcliffe
# This program is free software; you can redistribute it and/or modify it under
# the GNU General Public License as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.

use strict;
use warnings;

my $base;
if (@ARGV == 1 and $ARGV[0] !~ m[^-]) { $base = $ARGV[0] }
elsif (@ARGV == 2 and $ARGV[1] eq '--') { $base = $ARGV[1] }
else { die "Usage: $0 <base-revision>\n"; }

# Make sure the index is empty.
open my $fh, 'git status --porcelain |' or die "git status: $!\n";
grep m[^\w], <$fh> and die "You have staged changes. Unstage, stash, or commit them, and try again.\n";
close $fh or die "git status returned non-zero\n";

# Make sure submodules are up-to-date.
open $fh, 'git submodule summary |' or die "git submodule: $!\n";
grep m[^\S], <$fh> and die "Can not proceed with submodules out of sync.\n";
close $fh or die "git submodule returned non-zero\n";

# Enumerate all the candidate target SHAs.
open $fh, "git log --pretty=oneline '$base..HEAD' |" or die "git log: $!\n";
my(@revs, %msgs);
for my $line (<$fh>)
{
    chomp $line;
    $line =~ m[^([0-9a-f]{40}) (.*)$] or die "malformed log entry: $line\n";
    push @revs, $1;
    $msgs{$1} = $2;
}
close $fh or die "git log returned non-zero\n";
@revs or die "No commits to fix up.\n";

# Detect if any of the SHAs are already fixup! commits.
my %aliases;
for my $rev (@revs)
{
    $msgs{$rev} =~ m[^(fixup|squash)! (.*)$] or next;
    my $kind = $1;
    my $msg = shrinkws($2);
    my ($sha) = grep { substr(shrinkws($msgs{$_}), 0, length $msg) eq $msg } @revs;
    defined $sha and $aliases{$rev} = $sha;
    defined $sha or warn "WARNING: $rev looks like a $kind with no corresponding target: $msg\n\n";
}

# Read all changes in the working tree.
open $fh, 'git diff --ignore-submodules |' or die "git diff: $!\n";
my @lines = <$fh>;
close $fh or die "git diff returned non-zero\n";
@lines or die "Nothing to do.\n";

# Parse changes to produce a data structure of hunks.
my($file, @hunks, $binary);
for (my $i = 0; $i <= $#lines; $i++)
{
    my $line = $lines[$i];
    chomp $line;
    if ($line =~ m[^(?:diff|index|\+\+\+)])
    {}
    elsif ($line =~ m[^--- a/(.*)])
    {
        $file = $1;
    }
    elsif ($line =~ m[^@@ -([\d,]+) \+([\d,]+) @@])
    {
        defined $file or die "found @@ before --- in diff line $i\n";
        my @hunk = ($line);
        my(@remlines, @addlines);
        my($offset, $size) = split ',', $1;
        my($outoffset, $outsize) = split ',', $2;
        $size ||= 1;
        $outsize ||= 1;
        my $removal = 0;
        for (my $j = 0; $j < $size; )
        {
            $line = $lines[++$i];
            chomp $line;
            $line =~ m[^-] and push @remlines, $offset + $j;
            $line =~ m[^\+] and ! $removal and push @addlines, $offset + $j;
            $line !~ m[^\+] and $j++;
            $removal = $line !~ m[^ ];
            push @hunk, $line;
        }
        push @hunks, {
            file => $file,           lines => \@hunk,
            offset => $offset,       size => $size,
            outoffset => $outoffset, outsize => $outsize,
            remlines => \@remlines,  addlines => \@addlines
        };
    }
    elsif ($line =~ m[^Binary files])
    {
        $binary = 1;
    }
    else { die "malformed diff output line $i:\n$line\n" }
}
$binary and print "Changes in binary files ignored.\n";

# For each hunk, use git blame to identify the commit(s) that it could fix up.
my(%fixups, %fails);
for my $hunk (@hunks)
{
    my @shas;
    if (@{$hunk->{remlines}})
    {
        push @shas, map blame($hunk->{file}, $_), @{$hunk->{remlines}};
    }
    elsif (not @{$hunk->{addlines}})
    {
        die "noop hunk at $hunk->{file}:$hunk->{offset}\n";
    }

    push @shas, map blame($hunk->{file}, $_ - 1), @{$hunk->{addlines}};
    push @shas, map blame($hunk->{file}, $_    ), @{$hunk->{addlines}};
    @shas = sort revorder uniq(map { aliasof($_) } grep reachable($_), @shas);

    if (@shas == 1)
    {
        push @{$fixups{$shas[0]}{$hunk->{file}}}, $hunk;
    }
    elsif (@shas > 1)
    {
        $fails{$hunk->{file}}{$hunk->{lines}[0]} = [
            'ambiguous commit:',
            map { 'could be '.substr($_,0,7).' '.substr($msgs{$_},0,55) } @shas
        ];
    }
    else
    {
        $fails{$hunk->{file}}{$hunk->{lines}[0]} = ['no relevant commit found'];
    }
}

# Apply the hunks to the index and create the fixup! commits.
for my $sha (sort revorder keys %fixups)
{
    print "Fixing up $sha\n";
    open $fh, '| git apply --cached -' or die "git apply: $!\n";
    for $file (keys %{$fixups{$sha}})
    {
        print "  $file\n";
        print "    $_->{lines}[0]\n" for @{$fixups{$sha}{$file}};
        print $fh "--- a/$file\n";
        print $fh "+++ b/$file\n";
        for my $hunk (@{$fixups{$sha}{$file}})
        {
            print $fh join("\n", @{$hunk->{lines}}, '');
        }
    }
    close $fh or die "git apply returned non-zero\n";
    system(qw(git commit), "--fixup=$sha") == 0 or die "git commit: $!\n";
    print "\n";
}

# Report if git blame failed to find an unambiguous target commit for any hunk.
%fails and print "FAILED HUNKS:\n";
for my $file (sort keys %fails)
{
    print "  $file\n";
    if (uniq(map { join "\n", @$_ } values %{$fails{$file}}) == 1)
    {
        print "    $_\n" for @{(values %{$fails{$file}})[0]};
    }
    else
    {
        for my $hunk (sort hunkorder keys %{$fails{$file}})
        {
            print "    $hunk\n";
            print "      $_\n" for @{$fails{$file}{$hunk}};
        }
    }
}

exit(%fixups ? 0 : 1);

### Subroutines ################################################################

# Replace consecutive whitespace characters with a single space.
sub shrinkws
{
    my ($str) = @_;
    $str =~ s[^\s+][];
    $str =~ s[\s+$][];
    $str =~ s[\s+][ ]g;
    return $str;
}

# Invoke git blame to identify the origin of a specific line in a file.
sub blame
{
    my ($file, $line) = @_;
    $line >= 0 or return undef;
    open my $fh, "git blame -l -L $line,+1 HEAD '$file' |" or die "git blame: $!\n";
    my $blame = <$fh>;
    chomp $blame;
    $blame =~ m[^([0-9a-f]{40})] or die "malformed blame output: $blame\n";
    close $fh or die "git blame returned non-zero\n";
    return $1;
}

# If the given SHA is already a fixup! commit, return the SHA of the candidate
# commit that it is targetting, else return the given SHA.
sub aliasof
{
    my ($sha) = @_;
    my $alias = $aliases{$sha};
    return defined($alias) ? $alias : $sha;
}

# Remove duplicate entries from a list.
sub uniq
{
    my %hash;
    $hash{$_} = 1 for @_;
    return keys %hash;
}

# True if the given SHA is one of the candidate SHAs.
sub reachable
{
    my ($sha) = @_;
    return defined($sha) && grep $_ eq $sha, @revs;
}

# A comparator for use with sort(), which sorts SHAs by their order in the log.
sub revorder
{
    my ($ai) = grep $revs[$_] eq $a, 0..$#revs;
    my ($bi) = grep $revs[$_] eq $b, 0..$#revs;
    return $bi <=> $ai;
}

# A comparator for use with sort(), which sorts diff hunk @@ lines.
sub hunkorder
{
    $a =~ m[(\d+)];
    my $ai = $1;
    $b =~ m[(\d+)];
    my $bi = $1;
    return $ai <=> $bi;
}
