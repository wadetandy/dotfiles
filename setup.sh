#!/bin/bash

HOME=`echo ~/`
DOTFILES=$(cd $(dirname "$0"); pwd)

ln -s $DOTFILES/vimrc $HOME/.vimrc
ln -s $DOTFILES/bashrc $HOME/.bashrc
ln -s $DOTFILES/inputrc $HOME/.inputrc

