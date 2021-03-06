if has('gui_running')
   finish
endif

hi clear
set background=dark
if exists("syntax_on")
    syntax reset
endif

let colors_name="mycterm"
hi Normal ctermfg=255 ctermbg=235
hi Comment ctermfg=45
hi LineNr ctermfg=242 ctermbg=235
hi Constant ctermfg=5
hi PreProc ctermfg=171
hi Statement ctermfg=70 cterm=bold
hi SpecialKey ctermfg=167
hi Type ctermfg=76
hi Identifier ctermfg=255 cterm=none
hi Function cterm=bold  ctermfg=35
hi Search ctermbg=35 ctermfg=black
hi Visual ctermbg=white ctermfg=black
hi Pmenu ctermbg=22 ctermfg=white
hi PmenuSel ctermbg=darkblue ctermfg=white

hi! def link Directory Function
hi! def link CursorLine Search
hi! def link Special Function
hi! def link Title Function
hi! def link ModeMsg Function
hi! def link String PreProc
