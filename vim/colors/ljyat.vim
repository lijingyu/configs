if !has('gui_running')
   finish
endif

hi clear
set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="ljyat"

if exists("g:molokai_original")
    let s:molokai_original = g:molokai_original
else
    let s:molokai_original = 0
endif


hi Pmenu     guibg=DarkGreen	 guifg=white
hi PmenuSel  guibg=DarkBlue 	 guifg=white

hi Boolean         guifg=gold4
hi String          term=underline cterm=underline ctermfg=9 guifg=#80a0ff 
hi Comment    	   term=bold ctermfg=5 gui=italic guifg=#70665E
hi Constant        guifg=#F94C87           "   gui=bold
hi Folded          guifg=white guibg=#403D3D 
hi FoldColumn      guifg=white guibg=#403D3D 
hi Statement       term=bold ctermfg=14 gui=bold guifg=#86C711
"hi DefinedName 	   term=underline ctermfg=9 guifg=#ff80ff 
"hi EnumerationValue     guifg=#21BC71
"hi EnumerationValue term=underline ctermfg=9 guifg=#ff80ff 
hi Function        	guifg=#21BC71 gui=bold
hi Keyword        guifg=#E6C84F   gui=NONE
hi DefinedName 	  guifg=#E6C84F   gui=NONE 
hi EnumerationValue guifg=#E6C84F   gui=NONE

hi Type            guifg=#6AA86A 
hi VertSplit       guifg=#808080 guibg=#080808 gui=bold
hi VisualNOS                     guibg=#403D3D
hi Visual                        guibg=#403D3D
hi Member          gui=NONE
hi GlobalVariable   guifg=orange 
hi Normal ctermfg=252 ctermbg=234 guifg=#e3e0d7 guibg=#242424 
hi CursorLine                    guibg=#293739
hi CursorColumn                  guibg=#293739
hi LineNr          guifg=#BCBCBC guibg=#232526
hi NonText         guifg=#BCBCBC guibg=#232526
hi StatusLine      guifg=black   guibg=#C2BFA5 gui=bold
hi Search          guifg=green guibg=black

hi! def link cLabel	    	Statement
hi! def link cConditional   Statement
hi! def link cRepeat		Statement
hi! def link cStatement     Statement
hi! def link TagListFileName StatusLine 

