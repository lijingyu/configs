" Vim color file - grayorange
" Generated by http://bytefluent.com/vivify 2021-12-11
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "grayorange"

hi Normal guifg=#cfcfa2 guibg=#204040 guisp=#204040 gui=NONE ctermfg=230 ctermbg=238 cterm=NONE
hi SpecialComment guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi Title guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi Ignore guifg=#000000 guibg=NONE guisp=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
hi Debug guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi PMenuSbar guifg=NONE guibg=#7f7f7f guisp=#7f7f7f gui=NONE ctermfg=NONE ctermbg=8 cterm=NONE
hi Identifier guifg=#e6e6fa guibg=NONE guisp=NONE gui=NONE ctermfg=189 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi Todo guifg=#000000 guibg=#ffd700 guisp=#ffd700 gui=NONE ctermfg=NONE ctermbg=220 cterm=NONE
hi Special guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi LineNr guifg=#888888 guibg=#103030 guisp=#7f7f7f gui=NONE ctermfg=252 ctermbg=8 cterm=NONE
hi PMenuSel guifg=#88dd88 guibg=#949698 guisp=#949698 gui=NONE ctermfg=114 ctermbg=246 cterm=NONE
hi Delimiter guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi Function guifg=#e6e6fa guibg=NONE guisp=NONE gui=NONE ctermfg=189 ctermbg=NONE cterm=NONE
hi Cursor guifg=#204040 guibg=#f5f5dc guisp=#f5f5dc gui=NONE ctermfg=238 ctermbg=230 cterm=NONE
hi Error guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi PMenu guifg=#dddddd guibg=#545658 guisp=#545658 gui=NONE ctermfg=253 ctermbg=240 cterm=NONE
hi SpecialKey guifg=#ffd700 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Tag guifg=#ffdead guibg=NONE guisp=NONE gui=underline ctermfg=223 ctermbg=NONE cterm=underline
hi PMenuThumb guifg=NONE guibg=#cccccc guisp=#cccccc gui=NONE ctermfg=NONE ctermbg=252 cterm=NONE
hi Underlined guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi cursorim guifg=NONE guibg=#ff83fa guisp=#ff83fa gui=NONE ctermfg=NONE ctermbg=213 cterm=NONE
hi lcursor guifg=NONE guibg=#336242 guisp=#336242 gui=NONE ctermfg=NONE ctermbg=65 cterm=NONE
hi user1 guifg=#ffffff guibg=#00008b guisp=#00008b gui=bold ctermfg=15 ctermbg=18 cterm=bold
hi menu guifg=#fff8dc guibg=#233b5a guisp=#233b5a gui=NONE ctermfg=230 ctermbg=17 cterm=NONE
hi scrollbar guifg=NONE guibg=#233b5a guisp=#233b5a gui=NONE ctermfg=NONE ctermbg=17 cterm=NONE
hi user2 guifg=#87cefa guibg=#021a39 guisp=#021a39 gui=bold ctermfg=117 ctermbg=17 cterm=bold
hi vimerror guifg=#ffa500 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold

"hi PreProc guifg=#fcf003 guibg=NONE guisp=NONE gui=NONE ctermfg=108 ctermbg=NONE cterm=bold
hi Statement guifg=#35c4cc guibg=NONE guisp=NONE gui=bold ctermfg=108 ctermbg=NONE cterm=bold
hi Statement guifg=#44cfa1 guibg=NONE guisp=NONE gui=bold ctermfg=108 ctermbg=NONE cterm=bold
hi Comment guifg=#23c7c6 gui=italic guisp=#4d4d4d  ctermfg=143 ctermbg=239 cterm=underline
hi Constant guifg=indianred1 guibg=NONE guisp=NONE gui=NONE ctermfg=223 ctermbg=NONE cterm=NONE

hi MarkWord1  ctermbg=Green    ctermfg=Black  guibg=#2E8B57 guifg=Black
hi MarkWord2  ctermbg=Cyan     ctermfg=Black  guibg=lightred    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=lightgreen guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=orange    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

hi! def link Type Statement
hi! def link Keyword Statement