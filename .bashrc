export PATH=.:$PATH
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
'\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

git config --global user.name "Matthew Leeds"
git config --global user.email "mwl458@gmail.com"
git config --global core.editor vim

mesg n

alias dir='ls -lrath'
alias inst='sudo apt-get install'
alias re='sudo shutdown -r now'
alias st='sudo shutdown -h now'
alias v='vim'
alias cbh1='ssh mwleeds@linux-01.cbhp.ua.edu'
alias cbh2='ssh mwleeds@linux-02.cbhp.ua.edu'
alias cls='clear'
# alias br100='echo 4000 | sudo tee /sys/class/backlight/intel_backlight/\
# brightness' 
# alias br50='echo 2000 | sudo tee /sys/class/backlight/intel_backlight/\
# brightness'
# alias br10='echo 400 | sudo tee /sys/class/backlight/intel_backlight/\
# brightness'
alias py='python3' 
alias ..='cd ..'
# alias cursor='sudo modprobe -r psmouse && sudo modprobe psmouse'
# alias wifi='cd ~/Desktop/rtl8723au && sudo ./install_wifi_drivers'
alias ohshit='git reset --hard && git clean -df'
alias up='sudo apt-get update && sudo apt-get upgrade'
alias mwleeds='ssh root@107.170.190.138'
alias myip='wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//''
alias usage='du -sh ./*'
alias toggleUSB='for i in {1..27}; do sudo acpitool -W $i; done'
