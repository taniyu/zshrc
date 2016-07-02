#!/bin/sh

# $1クローン先 $2クローンするプロジェクトのパス
clone_git_repo () {
    if [ -d $1 ]; then
	echo "既に $1 はクローンされています。"
    else
	git clone $2 $1
    fi
}

clone_git_repo "$HOME/zsh-completions" "https://github.com/zsh-users/zsh-completions.git"
clone_git_repo "$HOME/dircolors-solarized" "https://github.com/seebi/dircolors-solarized.git"
clone_git_repo "$HOME/z" "https://github.com/rupa/z.git"

echo "source $HOME/zshrc/.zshrc" >>  $HOME/.zshrc
echo "設定を書き込みました。"

