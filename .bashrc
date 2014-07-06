export PATH=.:$PATH
export PYTHONPATH=$PYTHONPATH:/home/matthew/Downloads/scipoptsuite-3.1.0/\
scip-3.1.0/interfaces/python
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
'\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$\[\033[00m\] "

git config --global user.name "Matthew Leeds"
git config --global user.email "mwl458@gmail.com"
git config --global core.editor vim

alias dir='ls -lrat'
alias inst='sudo apt-get install'
alias re='sudo shutdown -r now'
alias st='sudo shutdown -h now'
alias v='vim'
alias rolltide='ssh mwleeds@linux-02.cbhp.ua.edu'
alias cls='clear'
alias br100='echo 4000 | sudo tee /sys/class/backlight/intel_backlight/\
brightness' 
alias br50='echo 2000 | sudo tee /sys/class/backlight/intel_backlight/\
brightness'
alias br10='echo 400 | sudo tee /sys/class/backlight/intel_backlight/\
brightness'
alias rolltide1='ssh mwleeds@linux-01.cbhp.ua.edu'
alias py='python3' 
alias pycharm='cd ~/Desktop/pycharm-community-3.1.3/bin/ && ./pycharm.sh'
alias palm='ssh reudc09@user.palmetto.clemson.edu'
alias ..='cd ..'
alias cursor='sudo modprobe -r psmouse && sudo modprobe psmouse'
alias wifi='cd ~/Desktop/rtl8723au && sudo ./install_wifi_drivers'
alias ohshit='git reset --hard && git clean -df'
alias hetnet='cd ~/Desktop/HetNetSim/ && git status && ls'
alias r='~/Desktop/HetNetSim/bin/run'
alias m='cd ~/Desktop/HetNetSim && make'
alias memchk='cd ~/Desktop/HetNetSim/bin/ && valgrind ./run'
alias up='sudo apt-get update && sudo apt-get upgrade'
alias nlab='ssh hetnetsim@nlab.cs.clemson.edu'
