" Summary:     Beautify statusline
" Description:
"         This script is based on the light2011 colorscheme. Thanks for xiaohuyee <xiaohuyee@gmail.com>
"         to give us such a pretty gift. He did most of the work. I just
"         stood on his shoulders.
"         I am looking for a beautiful vim statusline for a long time but found nothing
"         until I met the light2011.
"         Last night I spent several hours to beautify my statusline, it looks good.
"         And now I give it to you.
" Screenshot: 
"         http://vimer.1063083.n5.nabble.com/beautiful-vim-statusline-td4777850.html
"         
" Maintainer: Tian Huixiong: <nedzqbear@gmail.com>
"             I'm very glad to receive your feedback. 
" Licence:    This script is released under the Vim License.
" Version:    1.0
" Update:     2011-09-07 
" Install:     
"         Put this file in ~/.vim/plugin on *nix.
"         Or put it in $vim/vimfiles/plugin on Windows.
" Tutorial:
"         Just use it, and change it.
"         When you edit it, do not erase trailing-blanks.
set laststatus=2
set statusline=
set statusline+=%-f\ %w\ 
"set statusline+=%{&ff=='unix'?'\\n':(&ff=='mac'?'\\r':'\\r\\n')}\ 
set statusline+=%{&fenc!=''?&fenc:&enc}\ \ \ 
"set statusline+=%Y\ 
set statusline+=col:%c\ \ \ line:%l/%L\ \ \ 
set statusline+=ascii:0x%02.4B\ 
"set statusline+=%-16{strftime(\"%Y-%m-%d\ %H:%M\")}\ 
set statusline+=%-3m 
