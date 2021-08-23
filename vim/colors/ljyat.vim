if !has('gui_running')
   finish
endif

hi clear
set background=dark
if version > 580
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="ljyat"

hi Pmenu     guibg=DarkGreen	 guifg=white
hi PmenuSel  guibg=DarkBlue 	 guifg=white
hi Boolean         guifg=gold4
hi Comment    	   term=bold ctermfg=5 gui=italic guifg=DeepSkyBlue3
hi Number          guifg=#F94C87
hi Folded          guifg=white guibg=#403D3D 
hi FoldColumn      guifg=white guibg=#403D3D 
hi Statement       term=bold ctermfg=14  guifg=#758900
hi clear Function
hi Title           guifg=#00a000 gui=bold
hi Keyword         guifg=#E6C84F   gui=NONE
hi Type            guifg=#2E8B57  gui=NONE
hi VertSplit       guifg=#808080 guibg=#080808 gui=bold
hi VisualNOS                     guibg=#403D3D
hi Visual          guifg=black   guibg=white
"hi Normal          guifg=#9c9c9c guibg=#002b36
hi Normal          guifg=#9c9c9c guibg=#1b1b1b
hi CursorColumn                  guibg=#293739
hi Cursor          guifg=white guibg=red
hi CursorLine           guibg=#003355
hi LineNr          guifg=#606060 guibg=#222222
hi NonText         guifg=#BCBCBC guibg=#232526
hi StatusLine      guifg=black   guibg=#C2BFA5 gui=bold
hi Search          gui=bold guifg=black guibg=#00AF5F
hi String          guifg=#FF80FF
hi Directory       guifg=yellow
hi DefinedName     guifg=#FFCC00
hi WarningMsg      term=standout ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
hi clear Constant

hi! def link User1 Search
hi! def link ModeMsg     Directory
hi! def link Typedef        Structure
hi! def link CTagsType        Structure
hi! def link StatusLineNC   StatusLine
hi! def link cLabel	    	Statement
hi! def link cConditional   Statement
hi! def link cRepeat		Statement
hi! def link cStatement     Statement
hi! def link TagListFileName StatusLine 
hi! def link EnumerationValue  DefinedName 

hi! def link Identifier      Normal
hi! def link Question  Type
hi! def link MoreMsg   Title
"for java
hi! def link Method     Function
hi  Class           guifg=#00E000 gui=NONE

" default colors/groups for mark plugin
" you may define your own colors in you vimrc file, in the form as below:
hi MarkWord1  ctermbg=Cyan     ctermfg=Black  guibg=#8CCBEA    guifg=Black
hi MarkWord2  ctermbg=Green    ctermfg=Black  guibg=#A4E57E    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=#FF7272    guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

