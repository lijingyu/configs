" Vim color file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Jul 23

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "default"
hi Comment  term=bold ctermfg=5 guifg=SlateBlue
hi Keyword term=standout ctermfg=4 guifg=Brown    
hi Normal guibg=#CAE8F0 guifg=Black
hi Comment  gui=italic
hi cStatement term=standout ctermfg=4 guifg=Brown cterm=bold
hi Identifier term=underline ctermfg=3 guifg=DarkCyan gui=bold

hi! def link cLabel	    	Statement
hi! def link cConditional   Statement
hi! def link cRepeat		Statement
hi! def link cStatement     Statement
" vim: sw=2

hi User1 guifg=white  guibg=black  
hi User2 guifg=white  guibg=black  
hi User3 guifg=white  guibg=black  
hi User4 guifg=white  guibg=black  
hi User5 guifg=white  guibg=black  
