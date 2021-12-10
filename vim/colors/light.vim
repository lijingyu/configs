" Vim color file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Jul 23

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
" Remove all existing highlighting and set the defaults.
hi clear

set bg=light
" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "light"

hi Normal guibg=#83af9b
hi String guifg=#b00000
hi! def link Constant String
hi MoreMsg guifg=blue
hi Comment gui=italic
hi Type guifg=#a10303
hi Identifier guifg=darkgreen
hi Title guifg=#cb4b16
hi PreProc guifg=#a10303
hi CursorLine guibg=orange
hi WarningMsg guifg=darkred guibg=NONE

hi MarkWord1  ctermbg=Green    ctermfg=Black  guibg=#2E8B57 guifg=Black
hi MarkWord2  ctermbg=Cyan     ctermfg=Black  guibg=lightred    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=lightgreen guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=orange    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

" vim: sw=2
