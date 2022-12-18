
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# PERSONAL CONFIG

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

if [ -f ~/.hub.bash_completion.sh ]; then
    . ~/.hub.bash_completion.sh
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

git_dirty_indicator() {
  if git status --porcelain 2>/dev/null | grep -v "^??" >/dev/null; then
    echo -n "*"
  fi
}
export -f git_dirty_indicator

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export -f parse_git_branch

parse_git_branch_no_paren() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
export -f parse_git_branch_no_paren

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
export -f get_ssh_keys

export HISTSIZE=50000
export HISTTIMEFORMAT='%F %T %t'
export PS1="\[\033[01;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \
\"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\";\
 fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo \
 '\[\033[01;32m\]\u@\h'; fi)\[\033[01;37m\] \w\[\033[33m\]\$(parse_git_branch)\[\033[0;31m\]\$(git_dirty_indicator)\[\e[36m\]\$(get_ssh_keys)\[\033[00m\]\e[38;5;202m\[\033[00m\]\n↳ "
export PASSWORD_STORE_DIR=~/Desktop/password-store
export GOPATH=$HOME/work
export HISTCONTROL=ignoredups:erasedups
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig:/home/mwleeds/jhbuild/install/lib/pkgconfig:/home/mwleeds/jhbuild/install/share/pkgconfig:/usr/share/pkgconfig
export PATH=~/node_modules/tldr/bin:~/.local/bin:~/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin:$PATH
export LS_COLORS="rs=0:di=01;32:ln=38;5;51:mh=44;38;5;15:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=05;48;5;232;38;5;15:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;34:*.tar=38;5;9:*.tgz=38;5;9:*.arc=38;5;9:*.arj=38;5;9:*.taz=38;5;9:*.lha=38;5;9:*.lz4=38;5;9:*.lzh=38;5;9:*.lzma=38;5;9:*.tlz=38;5;9:*.txz=38;5;9:*.tzo=38;5;9:*.t7z=38;5;9:*.zip=38;5;9:*.z=38;5;9:*.Z=38;5;9:*.dz=38;5;9:*.gz=38;5;9:*.lrz=38;5;9:*.lz=38;5;9:*.lzo=38;5;9:*.xz=38;5;9:*.bz2=38;5;9:*.bz=38;5;9:*.tbz=38;5;9:*.tbz2=38;5;9:*.tz=38;5;9:*.deb=38;5;9:*.rpm=38;5;9:*.jar=38;5;9:*.war=38;5;9:*.ear=38;5;9:*.sar=38;5;9:*.rar=38;5;9:*.alz=38;5;9:*.ace=38;5;9:*.zoo=38;5;9:*.cpio=38;5;9:*.7z=38;5;9:*.rz=38;5;9:*.cab=38;5;9:*.jpg=38;5;13:*.jpeg=38;5;13:*.gif=38;5;13:*.bmp=38;5;13:*.pbm=38;5;13:*.pgm=38;5;13:*.ppm=38;5;13:*.tga=38;5;13:*.xbm=38;5;13:*.xpm=38;5;13:*.tif=38;5;13:*.tiff=38;5;13:*.png=38;5;13:*.svg=38;5;13:*.svgz=38;5;13:*.mng=38;5;13:*.pcx=38;5;13:*.mov=38;5;13:*.mpg=38;5;13:*.mpeg=38;5;13:*.m2v=38;5;13:*.mkv=38;5;13:*.webm=38;5;13:*.ogm=38;5;13:*.mp4=38;5;13:*.m4v=38;5;13:*.mp4v=38;5;13:*.vob=38;5;13:*.qt=38;5;13:*.nuv=38;5;13:*.wmv=38;5;13:*.asf=38;5;13:*.rm=38;5;13:*.rmvb=38;5;13:*.flc=38;5;13:*.avi=38;5;13:*.fli=38;5;13:*.flv=38;5;13:*.gl=38;5;13:*.dl=38;5;13:*.xcf=38;5;13:*.xwd=38;5;13:*.yuv=38;5;13:*.cgm=38;5;13:*.emf=38;5;13:*.axv=38;5;13:*.anx=38;5;13:*.ogv=38;5;13:*.ogx=38;5;13:*.aac=38;5;45:*.au=38;5;45:*.flac=38;5;45:*.mid=38;5;45:*.midi=38;5;45:*.mka=38;5;45:*.mp3=38;5;45:*.mpc=38;5;45:*.ogg=38;5;45:*.ra=38;5;45:*.wav=38;5;45:*.axa=39;5;45:*.oga=38;5;45:*.spx=38;5;45:*.xspf=38;5;45:"

shopt -s dotglob
shopt -s checkwinsize
shopt -s histappend

# miscellaneous aliases
alias ..='cd ..'
alias myip='wget -q -O - checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias proto='ctags -x --c-kinds=fp'
alias gitkey='ssh-add ~/.ssh/id_rsa'
alias gitst='git status --untracked-files=no'

# quilt -> dquilt (https://www.debian.org/doc/manuals/maint-guide/modify.en.html)
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion -o filenames dquilt

# this command deletes all git branches that have been merged into the current branch, master
alias delete-merged='git branch --merged | grep -E -v "^\*? master$" | sed "s/ *//" - | xargs git branch -d'

function random-word() {
    cat ~/Desktop/dotfiles/words | grep -v "'" | shuf -n 1 | tr -d "\n"
}
alias xkcd936='random-word && random-word && random-word && random-word && random-word && echo'
alias urandompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;'

# This gets the password for the first matching entry
function get-pass() {
    pass -c `pass | grep "$@" | cut -d' ' -f 2`
}

# The following two functions make it easier to use an unreviewed tag to keep
# track of which commits have been reviewed on a branch
function move-unreviewed() {
    prev_commit=`git rev-list -n1 "unreviewed"`
    git tag -d "unreviewed" >/dev/null
    next_commit=`git log --format='%H %P' --first-parent $(parse_git_branch_no_paren) -- | grep -F " $prev_commit" | tail -n1 | cut -f1 -d' '`
    git tag "unreviewed" $next_commit
    echo "unreviewed tag moved to commit `git log --oneline -n1 $next_commit`"
}

function show-unreviewed() {
    commit=`git rev-list -n1 "unreviewed"`
    git shw $commit
}

which hub &>/dev/null && eval "$(hub alias -s)" >/dev/null
[ x"$SSH_AGENT_PID" == "x" ] && eval `ssh-agent -s` > /dev/null || true
