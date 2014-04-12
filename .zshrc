#-- alias
alias ls='ls -F --color'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'

#-- color
export LS_COLORS='di=01;34;40:ln=01;36:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
if [ -d "~/dircolors-solarized/" ]; then
    eval $(dircolors ~/dircolors-solarized/dircolors.ansi-universal)
fi
## 256色
export TERM=xterm-256color

#-- 補完の設定
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

#-- prompt
local p_cdir="%B%F{blue}[%n@%m][%~]%f%b"$'\n'
local p_mark="%B%(?,%F{green},%F{red})%(!,#,>)%f%b"
PROMPT="$p_cdir%# $p_mark "

#-- git
## branchを表示
setopt prompt_subst
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
function rprompt-git-current-branch {
  local name st color gitdir action
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
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
     color=%F{red}
  fi
  echo "[$color$name$action%f%b] "
}

RPROMPT='`rprompt-git-current-branch`'



#-- 履歴関係
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

#-- tmux 用
PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
