#!/bin/bash

cd $HOME/dotfiles/
git add -A
git commit -m 'minor changes'
git push
echo -e "\nDone!\n"
cd $HOME
