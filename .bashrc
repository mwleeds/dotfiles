
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# PERSONAL CONFIG

export HISTSIZE=50000
export PATH=.:$PATH
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
'\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "
export CDPATH=::$HOME/Desktop
export PASSWORD_STORE_DIR=~/Desktop/password-store
export G_MESSAGES_DEBUG=all
export GOPATH=$HOME/work
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

git config --global user.name "Matthew Leeds"
git config --global user.email "mwl458@gmail.com"
git config --global core.editor vim
git config --global color.ui auto
git config --global bz.default-tracker bugzilla.gnome.org
git config --global bz.default-product gnome-builder
git config --global bz.default-component general
git config --global url.ssh://mwleeds@git.gnome.org/git/.insteadof gnome:

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

eval `ssh-agent -s` > /dev/null
