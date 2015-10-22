#======================================
#-- alias
#======================================
alias ls='ls -F --color'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'
alias gst="git status"
alias gch="git checkout"
alias gbr="git branch"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias glga="git log --graph --all --pretty=format:'%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gad="git add"
alias gcm="git commit"
alias gps="git push"
alias gpl="git pull"
alias be='bundle exec'

alias delete_merged_branches='git branch -d $(git branch -r --merged | grep origin/ | grep -v master | grep -v develop | sed s~origin/~~)'
#======================================
#-- color
#======================================
export LS_COLORS='di=01;34;40:ln=01;36:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    eval $(dircolors ~/dircolors-solarized/dircolors.ansi-universal)
## 256色
export TERM=xterm-256color

## tab補完に関するもの
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

#======================================
#-- tmux
#======================================
PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

#======================================
#-- z
#======================================
source $HOME/z/z.sh
