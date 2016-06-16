
# PERSONAL CONFIG

export PATH=.:$PATH
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
'\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "
export CDPATH=::$HOME/Desktop
export PASSWORD_STORE_DIR=~/ownCloud/.password-store

git config --global user.name "Matthew Leeds"
#git config --global user.email "mwl458@gmail.com"
git config --global core.editor vim

mesg n

shopt -s dotglob

alias ..='cd ..'
alias myip='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'

eval `ssh-agent -s` > /dev/null
