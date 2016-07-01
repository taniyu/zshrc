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
alias delete_merged_branches='git branch -d $(git branch -r --merged | grep origin/ | grep -v master | grep -v develop | sed s~origin/~~)'

alias be='bundle exec'
alias berails='bundle exec rails'
alias berake='bundle exec rake'
alias railsproduction='RAILS_ENV=production'
alias railsdevelopment='RAILS_ENV=development'
alias railstest='RAILS_ENV=test'
alias ts='tmux new-session -s'
alias tls='tmux list-sessions'
alias tksession='tmux kill-session -t'
alias tkserver='tmux kill-server'
#======================================
#-- color
#======================================
export LS_COLORS='di=01;34;40:ln=01;36:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    eval $(dircolors ~/dircolors-solarized/dircolors.ansi-universal)
## 256色
export TERM=xterm-256color

autoload -U colors && colors

#
# Color定義(あとで変更しやすいように)
#
TURQUOISE="%F{81}"
ORANGE="%F{166}"
HOSTNAME_C="%F{209}"
YELLOW="%F{yellow}"
CYAN="%F{cyan}"
PURPLE="%F{135}"
UNAME_C="%F{135}"
HOTPINK="%F{161}"
RED="%F{red}"
LIMEGREEN="%F{118}"
GRAY="%F{245}"
BRANCH_NAME="%F{195}"
RESET="%{${reset_color}%}"

#======================================
#-- 補完の設定
#======================================
## 大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## tab補完に関するもの
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
## gitやその他もろもろの補完 
fpath=(~/zsh-completions/src $fpath)
if [ -e "~/zsh-completions/src" ]; then
    fpath=(~/zsh-completions/src $fpath)
else
    fpath=(~/zshrc/.zsh/completion $fpath)
    ## セパレータの設定
    zstyle ':completion:*' list-separator '-->'
    zstyle ':completion:*:manuals' separate-sections true
fi

## 補完機能の有効化
autoload -Uz compinit; compinit
zstyle ':completion:*:default' menu select=2

#======================================
#-- prompt
#======================================

#------------------------------------------------
#  git用関数
#------------------------------------------------

git_prompt_stash_count () {
  local COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
#  if [ "$COUNT" -gt 0 ]; then
  echo "($COUNT)"
#  fi
}

git-current-branch() {
  local name st color gitdir action st_text
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi
  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  st=`git status 2> /dev/null`
  st_text=""
  if [[ -n `echo "$st" | grep "Untracked"` ]]; then
    st_text+="${YELLOW}?"
  fi
  if [[ -n `echo "$st" | grep "Changes not staged for commit"` ]]; then
    st_text+="${RED}*"
  fi
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    st_text+="${LIMEGREEN}${RESET}"
  fi
  echo "${st_text}${GRAY}`git_prompt_stash_count` ${LIMEGREEN}${name}${RESET}${action}${RESET}|"
}

autoload -Uz VCS_INFO_get_data_git && VCS_INFO_get_data_git 2> /dev/null
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt PROMPT_SUBST

PROMPT_GIT='`git-current-branch`'

local p_cdir="${UNAME_C}%n${RESET}@${HOSTNAME_C}%m${RESET} ${GRAY}[${PROMPT_GIT}${TURQUOISE}%~${RESET}${GRAY}]${RESET}"
local p_mark="${RESET}%B%(?,%F{green},%F{red})%(!,#,>)%f%b"
PROMPT="$p_cdir
%# $p_mark "

#======================================
#-- History
#======================================
HISTFILE=~/.zsh_histfile
HISTSIZE=10000
SAVEHIST=10000
## 履歴を複数端末間で共有
setopt share_history
## 重複するコマンドが記録される時古い方を削除
setopt hist_ignore_all_dups
## 直前のコマンドと同じ場合履歴に追加しない
setopt hist_ignore_dups
## 重複するコマンドが保存される時古い方を削除
setopt hist_save_no_dups

## cdで移動した場所を記録 cd -で利用可能
setopt auto_pushd
## 重複するものは保存しない
setopt pushd_ignore_dups

#======================================
#-- tmux
#======================================
PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

#======================================
#-- emacs client用
#======================================
Kill-emacsclient() {
    emacsclient -e '(kill-emacs)'
}
alias emc='emacsclient -nw -a ""'

#======================================
#-- z
#======================================
source $HOME/z/z.sh
