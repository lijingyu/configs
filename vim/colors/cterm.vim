hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name="cterm"
hi Normal ctermfg=255 ctermbg=235
hi Comment ctermfg=244
hi LineNr ctermfg=242 ctermbg=0
hi Constant ctermfg=13
hi PreProc ctermfg=13
hi Statement ctermfg=70 cterm=bold
hi SpecialKey ctermfg=167
hi Type ctermfg=green
hi Identifier cterm=bold  ctermfg=35
hi Search ctermbg=11 ctermfg=black
hi Visual ctermbg=white ctermfg=black

hi! def link Directory Function
hi! def link Special Function
hi! def link Title Function
hi! def link ModeMsg Function
