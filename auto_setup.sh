#!/bin/bash

if [ -e ~/bin/setup.sh ]; then
    if [ -e ~/bin/vim/vimrc ]; then
        rm -rf ~/.vim
        rm -rf ~/.vimrc
        ln -sf ~/bin/vim ~/.vim
        ln -sf ~/bin/vim/vimrc ~/.vimrc

        mkdir -p ~/.config/openbox ~/.config/tint2 ~/.local/share/fonts

        cp ~/bin/fonts/*.ttf ~/.local/share/fonts/
        cp ~/bin/fonts/sf/* ~/.local/share/fonts/

        cp ~/bin/wm/rc.xml ~/bin/wm/menu.xml  ~/.config/openbox
        cp ~/bin/wm/tint2rc ~/.config/tint2/
    fi
else
	echo "no exist ~/bin/setup.sh"
fi
