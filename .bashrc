
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# PERSONAL CONFIG

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

git_dirty_indicator() {
  if [[ -n "$(git status 2> /dev/null | tail -n1)" ]]; then
    if [[ $(git status 2> /dev/null | tail -n1) != *"nothing to commit"* ]]; then
      echo -n "*"
    fi
  fi
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

get_ssh_keys() {
    if ssh-add -l >/dev/null 2>&1; then
        NUM_SSH_KEYS=`ssh-add -l | wc -l`
        if [ "$NUM_SSH_KEYS" == "1" ]; then
            echo " ($NUM_SSH_KEYS key)"
        else
            echo " ($NUM_SSH_KEYS keys)"
        fi
    fi
}

under_jhbuild() {
    if [ "$UNDER_JHBUILD" == "true" ]; then
        echo " (jhb)"
    fi
}

export HISTSIZE=50000
export HISTTIMEFORMAT='%F %T %t'
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
 '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[0;31m\]\$(git_dirty_indicator)\[\e[36m\]\$(get_ssh_keys)\[\033[00m\]\e[38;5;202m\$(under_jhbuild)\[\033[00m\]\n↳ "
export CDPATH=::$HOME/Desktop
export PASSWORD_STORE_DIR=~/Desktop/password-store
export G_MESSAGES_DEBUG=all
export GOPATH=$HOME/work
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export ACBUILD_BIN_DIR=~/Desktop/acbuild/bin
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig:/home/mwleeds/jhbuild/install/lib/pkgconfig:/home/mwleeds/jhbuild/install/share/pkgconfig:/usr/share/pkgconfig
export MALINE=/home/mwleeds/maline
export PATH=$ACBUILD_BIN_DIR:$MALINE/bin:/usr/local/android-studio/bin:~/Android/Sdk/tools/:~/Android/Sdk/platform-tools:~/node_modules/tldr/bin:~/.local/bin:$PATH:.

mesg n

shopt -s dotglob
shopt -s checkwinsize
shopt -s histappend

# miscellaneous aliases
alias ..='cd ..'
alias myip='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias proto='ctags -x --c-kinds=fp'
alias night='nohup redshift -l 33.21:-87.54 >/dev/null 2>&1 &'
alias jgb='cd ~/jhbuild/checkout/gnome-builder && jhbuild shell'
alias gitkey='ssh-add ~/.ssh/github_id_rsa'
alias gplom='git pull origin master'
alias gpsom='git push origin master'
alias gitst='git status --untracked-files=no'

# this command deletes all git branches that have been merged into the current branch, master
alias delete-merged='git branch --merged | grep -E -v "^\*? master$" | sed "s/ *//" - | xargs git branch -d'

# this command prints a random line from a file that has up to 32,767 lines
function random-line() {
    n=$((RANDOM<<15|RANDOM))
    let "n %= $(wc -l "$@" | cut -d" " -f1)"
    sed -n $((n+1))p "$@"
}
alias random-word='random-line /usr/share/dict/words | tr -d "\n"'
alias xkcd936='random-word && random-word && random-word && random-word'

# This gets the password for the first matching entry
function get-pass() {
    pass -c `pass | grep "$@" | cut -d' ' -f 2`
}

# The following two functions make it easier to use an unreviewed tag to keep
# track of which commits have been reviewed on a branch
function move-unreviewed() {
    prev_commit=`git rev-list -n1 "unreviewed"`
    git tag -d "unreviewed" >/dev/null
    next_commit=`git log --format='%H %P' --all | grep -F " $prev_commit" | tail -n1 | cut -f1 -d' '`
    git tag "unreviewed" $next_commit
    echo "unreviewed tag moved to commit `git log --oneline -n1 $next_commit`"
}

function show-unreviewed() {
    commit=`git rev-list -n1 "unreviewed"`
    git shw $commit
}

eval `ssh-agent -s` > /dev/null
eval $(thefuck --alias)
