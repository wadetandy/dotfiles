#!/bin/bash

CUR_DIR=`pwd`
HOME=`echo ~/`
DOTFILES=$(cd $(dirname "$0"); pwd)

ln -s $DOTFILES/vimrc $HOME/.vimrc
ln -s $DOTFILES/bashrc $HOME/.bashrc
ln -s $DOTFILES/inputrc $HOME/.inputrc

mv $HOME/.vim $HOME/.bak.vim
ln -s $DOTFILES/.vim $HOME/.vim

mkdir -p $DOTFILES/.vim/tmp/backup
mkdir -p $DOTFILES/.vim/tmp/swap
mkdir -p $DOTFILES/.vim/tmp/undo

cd $DOTFILES/.vim
git submodule update --init

cd $CUR_DIR
