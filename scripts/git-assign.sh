#!/bin/bash

# Usage information:
#   assign [-n | --dry-run] [-d | --default-root] [-M[<n>] | --find-renames[=<n>]] [<root>]
# 
#   -n | --dry-run:
#       If dry run is specified no lasting changes are made.
#       Instead it will just output which files it would assign to which commits
#   -d | --default-root:
#       Specifies the default root.
#       If both the default root and root are specified, only root is considered.
#       This is meant for a git alias, where you can specify 'main' or 'master' as default
#       and still overwrite it when using the alias.
#   -M[<n>] | --find-renames[=<n>]:
#       If specified, will attempt to also assign renames.
#       The format is the same as for git diff.
#       (see https://git-scm.com/docs/git-diff#Documentation/git-diff.txt--Mltngt)
#   root:
#       This script will only look at commits starting from (but excluding) the root commit.
#       This can be used to ensure that no fixup commits will be created for commits that
#       aren't on the current branch.
#       Files that were last changed in or before this commit will simply be left uncomitted.

# Default options
DRY_RUN=false
DEFAULT_ROOT=""
ROOT=""
FIND_RENAMES=()

# Read potential options
while [ "$1" != "" ];
do
    case $1 in
        -n | --dry-run)
            DRY_RUN=true
            ;;
        -d | --default-root)
            shift
            DEFAULT_ROOT="$1"
            ;;
        -M* | --find-renames*)
            FIND_RENAMES=("$1")
            ;;
        -*)
            printf "unrecognised option: %s" "$1"
            exit 1
            ;;
        *)
            if [[ $ROOT == "" ]];
            then
                ROOT="$1"
            else
                printf "Cannot specify root twice (specified both '%s' and '%s')" "${ROOT}" "$1"
                exit 1
            fi
            ;;
    esac
    shift
done

if [[ $DEFAULT_ROOT != "" && $ROOT == "" ]];
then
    ROOT="${DEFAULT_ROOT}"
fi

# For each changed file find the commit in which it was last changed.
# lastCommits is an associative array with the commit hash as key and
# a newline separated list of the file names as value.
declare -A lastCommits
IFS=$'\n'; for file in $(git diff --name-only);
do
    if [[ $ROOT != "" ]];
    then
        commit=$(git log -1 --format="format:%H" "${ROOT}.." -- "${file}")

        # When a root is specified, a file could have no changes before that.
        # We simply ignore that file then.
        if [[ $commit != "" ]];
        then
            lastCommits[$commit]+="$file"$'\n'
        fi
    else
        commit=$(git log -1 --format="format:%H" -- "${file}")
        lastCommits["$commit"]+="$file"$'\n'
    fi
done

declare -A renamedFiles=()
if (( ${#FIND_RENAMES[@]} ));
then
    # first add all files indvidually as intent-to-add
    intentToAdd=$(git ls-files -oX .gitignore)
    for file in $intentToAdd;
    do
        git add -N "$file"
    done

    # get all renames and save them into an associative array
    while IFS=$'\t' read -r origFile newFile;
    do
        renamedFiles["$origFile"]="$newFile"
    done < <(git diff --name-status --diff-filter=R "${FIND_RENAMES[@]}" | cut -f 2,3)

    # remove intent-to-add
    for file in $intentToAdd;
    do
        git reset -q -- "$file"
    done
fi

# For each commit in lastCommits, we now add all of the associated
# files and then create a fixup commit for the respective commit

add_file() {
    if [[ $DRY_RUN == false ]];
    then
        git add "$1"
    else
        printf "\t%s\n" "$1"
    fi
}


IFS=$'\n'
for commit in "${!lastCommits[@]}";
do
    if [[ $DRY_RUN == true ]];
    then
        printf "%s\n" "$(git log -1 --color --format="format:%C(auto)%h%d%Creset: (%aN) %s" "${commit}")"
    fi

    for file in ${lastCommits[$commit]};
    do
        add_file "$file"
        if [[ -v "renamedFiles[${file}]" ]];
        then
            add_file "${renamedFiles[${file}]}"
        fi
    done

    if [[ $DRY_RUN == false ]];
    then
        git commit --fixup "${commit}"
    fi
done
unset IFS

