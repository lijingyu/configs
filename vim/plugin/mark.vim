" Script Name: mark.vim
" Version:     1.1.10 (global version)
" Last Change: January 16, 2015
" Author:      Yuheng Xie <thinelephant@gmail.com>
" Contributor: Luc Hermitte
"
" Description: a little script to highlight several words in different colors
"              simultaneously
"
" Usage:       :Mark regexp   to mark a regular expression
"              :Mark regexp   with exactly the same regexp to unmark it
"              :Mark          to clear all marks
"
"              You may map keys for the call in your vimrc file for
"              convenience. The default keys is:
"              Highlighting:
"                Normal \m  mark or unmark the word under or before the cursor
"                       \r  manually input a regular expression
"                       \n  clear current mark (i.e. the mark under the cursor),
"                           or clear all marks
"                Visual \m  mark or unmark a visual selection
"                       \r  manually input a regular expression
"              Searching:
"                Normal \*  jump to the next occurrence of current mark
"                       \#  jump to the previous occurrence of current mark
"                       \/  jump to the next occurrence of ANY mark
"                       \?  jump to the previous occurrence of ANY mark
"                        *  behaviors vary, please refer to the table on
"                        #  line 123
"                combined with VIM's / and ? etc.
"
"              The default colors/groups setting is for marking six
"              different words in different colors. You may define your own
"              colors in your vimrc file. That is to define highlight group
"              names as "MarkWordN", where N is a number. An example could be
"              found below.
"
" Bugs:        some colored words could not be highlighted
"
" Changes:
" 16th Jan 2015, Yuheng Xie: add auto event WinEnter
" (*) added auto event WinEnter for reloading highlights after :split, etc.
"
" 29th Jul 2014, Yuheng Xie: call matchadd()
" (*) added call to VIM 7.1 matchadd(), make highlighting keywords possible
"
" 10th Mar 2006, Yuheng Xie: jump to ANY mark
" (*) added \* \# \/ \? for the ability of jumping to ANY mark, even when the
"     cursor is not currently over any mark
"
" 20th Sep 2005, Yuheng Xie: minor modifications
" (*) merged MarkRegexVisual into MarkRegex
" (*) added GetVisualSelectionEscaped for multi-lines visual selection and
"     visual selection contains ^, $, etc.
" (*) changed the name ThisMark to CurrentMark
" (*) added SearchCurrentMark and re-used raw map (instead of VIM function) to
"     implement * and #
"
" 14th Sep 2005, Luc Hermitte: modifications done on v1.1.4
" (*) anti-reinclusion guards. They do not guard colors definitions in case
"     this script must be reloaded after .gvimrc
" (*) Protection against disabled |line-continuation|s.
" (*) Script-local functions
" (*) Default keybindings
" (*) \r for visual mode
" (*) uses <leader> instead of "\"
" (*) do not mess with global variable g:w
" (*) regex simplified -> double quotes changed into simple quotes.
" (*) strpart(str, idx, 1) -> str[idx]
" (*) command :Mark
"     -> e.g. :Mark Mark.\{-}\ze(

" default colors/groups
" you may define your own colors in you vimrc file, in the form as below:
hi MarkWord1  ctermbg=Green    ctermfg=Black  guibg=#2E8B57 guifg=Black
hi MarkWord2  ctermbg=Cyan     ctermfg=Black  guibg=lightred    guifg=Black
hi MarkWord3  ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi MarkWord4  ctermbg=Red      ctermfg=Black  guibg=lightgreen guifg=Black
hi MarkWord5  ctermbg=Magenta  ctermfg=Black  guibg=orange    guifg=Black
hi MarkWord6  ctermbg=Blue     ctermfg=Black  guibg=#9999FF    guifg=Black

" Anti reinclusion guards
if exists('g:loaded_mark') && !exists('g:force_reload_mark')
    finish
endif

let s:state = {'dir':'', 're':'', 'line':0, 'end':0}

" Support for |line-continuation|
let s:save_cpo = &cpo
set cpo&vim

" Default bindings

if !hasmapto('<Plug>MarkSet', 'n')
    nmap <unique> <silent> <leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkSet', 'v')
    vmap <unique> <silent> <leader>m <Plug>MarkSet
endif
if !hasmapto('<Plug>MarkRegex', 'n')
    nmap <unique> <silent> <leader>r <Plug>MarkRegex
endif
if !hasmapto('<Plug>MarkRegex', 'v')
    vmap <unique> <silent> <leader>r <Plug>MarkRegex
endif

nnoremap <silent> <Plug>MarkSet   :call
            \ <sid>MarkCurrentWord()<cr>
vnoremap <silent> <Plug>MarkSet   <c-\><c-n>:call
            \ <sid>DoMark(<sid>GetVisualSelectionEscaped("enV"))<cr>
nnoremap <silent> <Plug>MarkRegex :call
            \ <sid>MarkRegex()<cr>
vnoremap <silent> <Plug>MarkRegex <c-\><c-n>:call
            \ <sid>MarkRegex(<sid>GetVisualSelectionEscaped("N"))<cr>

" Here is a sumerization of the following keys' behaviors:
" 
" First of all, \#, \? and # behave just like \*, \/ and *, respectively,
" except that \#, \? and # search backward.
"
" \*, \/ and *'s behaviors differ base on whether the cursor is currently
" placed over an active mark:
"
"       Cursor over mark                  Cursor not over mark
" ---------------------------------------------------------------------------
"  \*   jump to the next occurrence of    jump to the next occurrence of
"       current mark, and remember it     "last mark".
"       as "last mark".
"
"  \/   jump to the next occurrence of    same as left
"       ANY mark.
"
"   *   if \* is the most recently used,  do VIM's original *
"       do a \*; otherwise (\/ is the
"       most recently used), do a \/.

nnoremap <silent> <leader>/ :call <sid>SearchAnyMark()<cr>
nnoremap <silent> <leader>? :call <sid>SearchAnyMark("b")<cr>

command! -nargs=? Mark call s:DoMark(<f-args>)
command! -nargs=0 MarkClear call s:DoMarkClear()

autocmd! WinEnter * call s:UpdateMark()

" Functions

function! s:MarkCurrentWord()
    let w = s:PrevWord()
    if w != ""
        call s:DoMark('\<' . w . '\>')
    endif
endfunction

function! s:GetVisualSelection()
    let save_a = @a
    silent normal! gv"ay
    let res = @a
    let @a = save_a
    return res
endfunction

function! s:GetVisualSelectionEscaped(flags)
    " flags:
    "  "e" \  -> \\  
    "  "n" \n -> \\n  for multi-lines visual selection
    "  "N" \n removed
    "  "V" \V added   for marking plain ^, $, etc.
    let result = s:GetVisualSelection()
    let i = 0
    while i < strlen(a:flags)
        if a:flags[i] ==# "e"
            let result = escape(result, '\')
        elseif a:flags[i] ==# "n"
            let result = substitute(result, '\n', '\\n', 'g')
        elseif a:flags[i] ==# "N"
            let result = substitute(result, '\n', '', 'g')
        elseif a:flags[i] ==# "V"
            let result = result
        endif
        let i = i + 1
    endwhile
    return result
endfunction

" manually input a regular expression
function! s:MarkRegex(...) " MarkRegex(regexp)
    let regexp = ""
    if a:0 > 0
        let regexp = a:1
    endif
    call inputsave()
    echohl Moremsg
    let r = input(" Input pattern to mark: ", regexp)
    echohl None
    call inputrestore()
    if r != ""
        call s:DoMark(r)
    endif
endfunction

" define variables if they don't exist
function! s:InitMarkVariables()
    if !exists("g:mwHistAdd")
        let g:mwHistAdd = "/@"
    endif
    if !exists("g:mwCycleMax")
        let i = 1
        while hlexists("MarkWord" . i)
            let i = i + 1
        endwhile
        let g:mwCycleMax = i - 1
    endif
    if !exists("g:mwCycle")
        let g:mwCycle = 1
    endif
    let i = 1
    while i <= g:mwCycleMax
        if !exists("g:mwWord" . i)
            let g:mwWord{i} = ""
        endif
        let i = i + 1
    endwhile
    if !exists("g:mwLastSearched")
        let g:mwLastSearched = ""
    endif
endfunction

" return the word under or before the cursor
function! s:PrevWord()
    let line = getline(".")
    if line[col(".") - 1] =~ '\w'
        return expand("<cword>")
    else
        return substitute(strpart(line, 0, col(".") - 1), '^.\{-}\(\w\+\)\W*$', '\1', '')
    endif
endfunction

function! s:DoMarkClear()
    call s:InitMarkVariables()

    let i = 1
    while i <= g:mwCycleMax
        if g:mwWord{i} != ""
            let g:mwWord{i} = ""
            let lastwinnr = winnr()
            let winview = winsaveview()
            windo silent! call matchdelete(3333 + i)
            exe lastwinnr . "wincmd w"
            call winrestview(winview)
        endif
        let i = i + 1
    endwhile
    let g:mwLastSearched = ""
    return 0
endfunction

let s:match_str = ""
function! s:CheckCurCharInMark(regexp)
    let s:match_str = ""
    "init match_str
    let s:match_str = ""
    "if it is not word mark ignore this check
    if a:regexp[0:1] != '\<' || a:regexp[-2:-1] != '\>'
        return
    endif
    let save_pos = getpos('.')
    let w = s:AnyMark()
    if w == ""
        return
    endif

    let match_line = search(w,'c')
    if (match_line == save_pos[1]) && (getpos('.')[2] == save_pos[2])
        call setpos('.', save_pos)
    else
        let match_line = search(w, "b")
    endif

    if (match_line == 0) || (match_line != save_pos[1])
        call setpos('.', save_pos)
        return -1
    endif
    " get match start col in current line
    let col_s = getpos('.')[2]

    " get match end col in current line
    if search(w, 'ce') == 0
        call setpos('.', save_pos)
        return -1
    endif
    let col_e = getpos('.')[2]

    " get match end col in current line
    let col_c = save_pos[2]

    if col_c >= col_s && col_c <= col_e
        let s:match_str = getline('.')[col_s-1:col_e-1]
    endif
    call setpos('.', save_pos)
    return 0
endfunction

" mark or unmark a regular expression
function! s:DoMark(...) " DoMark(regexp)
    " define variables if they don't exist
    call s:InitMarkVariables()

    " clear all marks if regexp is null
    let regexp = ""
    if a:0 > 0
        let regexp = a:1
    endif
    if regexp == ""
        let i = 1
        while i <= g:mwCycleMax
            if g:mwWord{i} != ""
                let g:mwWord{i} = ""
                let lastwinnr = winnr()
                let winview = winsaveview()
                windo silent! call matchdelete(3333 + i)
                exe lastwinnr . "wincmd w"
                call winrestview(winview)
            endif
            let i = i + 1
        endwhile
        let g:mwLastSearched = ""
        return 0
    endif

    " clear the mark if it has been marked
    call s:CheckCurCharInMark(regexp)
    let i = 1
    while i <= g:mwCycleMax
        if (regexp == g:mwWord{i}) || ((s:match_str != "")&&(s:match_str == g:mwWord{i}))
            if g:mwLastSearched == g:mwWord{i}
                let g:mwLastSearched = ""
            endif
            let g:mwWord{i} = ""
            let lastwinnr = winnr()
            let winview = winsaveview()
            windo silent! call matchdelete(3333 + i)
            exe lastwinnr . "wincmd w"
            call winrestview(winview)
            return 0
        endif
        let i = i + 1
    endwhile

    " add to history
    if stridx(g:mwHistAdd, "/") >= 0
        call histadd("/", regexp)
    endif
    if stridx(g:mwHistAdd, "@") >= 0
        call histadd("@", regexp)
    endif

    " quote regexp with / etc. e.g. pattern => /pattern/
    let quote = "/?~!@#$%^&*+-=,.:"
    let i = 0
    while i < strlen(quote)
        if stridx(regexp, quote[i]) < 0
            let quoted_regexp = quote[i] . regexp . quote[i]
            break
        endif
        let i = i + 1
    endwhile
    if i >= strlen(quote)
        return -1
    endif

    " choose an unused mark group
    let i = 1
    while i <= g:mwCycleMax
        if g:mwWord{i} == ""
            let g:mwWord{i} = regexp
            if i < g:mwCycleMax
                let g:mwCycle = i + 1
            else
                let g:mwCycle = 1
            endif
            let lastwinnr = winnr()
            let winview = winsaveview()
            windo silent! call matchdelete(3333 + i)
            windo silent! call matchadd("MarkWord" . i, g:mwWord{i}, -10, 3333 + i)
            exe lastwinnr . "wincmd w"
            call winrestview(winview)
            return i
        endif
        let i = i + 1
    endwhile

    " choose a mark group by cycle
    let i = 1
    while i <= g:mwCycleMax
        if g:mwCycle == i
            if g:mwLastSearched == g:mwWord{i}
                let g:mwLastSearched = ""
            endif
            let g:mwWord{i} = regexp
            if i < g:mwCycleMax
                let g:mwCycle = i + 1
            else
                let g:mwCycle = 1
            endif
            let lastwinnr = winnr()
            let winview = winsaveview()
            windo silent! call matchdelete(3333 + i)
            windo silent! call matchadd("MarkWord" . i, g:mwWord{i}, -10, 3333 + i)
            exe lastwinnr . "wincmd w"
            call winrestview(winview)
            return i
        endif
        let i = i + 1
    endwhile
endfunction

" update mark colors
function! s:UpdateMark()
    " define variables if they don't exist
    call s:InitMarkVariables()

    let i = 1
    let lastwinnr = winnr()
    while i <= g:mwCycleMax
        windo silent! call matchdelete(3333 + i)
        if g:mwWord{i} != ""
            " quote regexp with / etc. e.g. pattern => /pattern/
            let quote = "/?~!@#$%^&*+-=,.:"
            let j = 0
            while j < strlen(quote)
                if stridx(g:mwWord{i}, quote[j]) < 0
                    let quoted_regexp = quote[j] . g:mwWord{i} . quote[j]
                    break
                endif
                let j = j + 1
            endwhile
            if j >= strlen(quote)
                continue
            endif

            windo silent! call matchadd("MarkWord" . i, g:mwWord{i}, -10, 3333 + i)
        endif
        let i = i + 1
    endwhile
    exe lastwinnr . "wincmd w"
endfunction

" combine all marks into one regexp
function! s:AnyMark()
    " define variables if they don't exist
    call s:InitMarkVariables()

    let w = ""
    let i = 1
    while i <= g:mwCycleMax
        if g:mwWord{i} != ""
            if w != ""
                let w = w . '\|' . g:mwWord{i}
            else
                let w = g:mwWord{i}
            endif
        endif
        let i = i + 1
    endwhile
    return w
endfunction

function! SearchWarningMsg(w, flags)
    if a:flags == "b"
        let show_marks = " Search Hit Top: " . a:w
    else
        let show_marks = " Search Hit Bottom: " . a:w
    endif

    if strlen(show_marks) >= &columns
        let show_marks = show_marks[0:(&columns - 6)] . " ..."
    endif

    echohl Todo
    echo show_marks
    echohl None
    return
endfunction

" search any mark
function! s:SearchAnyMark(...) " SearchAnyMark(flags)
    let flags = ""
    if a:0 > 0
        let flags = a:1
    endif
    let w = s:AnyMark()

    if w == ""
        echohl Todo
        echo " No marks!!!"
        echohl None
        return
    endif

    if (s:state.re == w) && (s:state.end == 1) && (line('.') == s:state.line) && (s:state.dir == flags)
        call SearchWarningMsg(w, flags)
        return
    endif

    let s:state.re = w
    let s:state.line = line('.')
    let s:state.dir = flags
    if search(w, flags) == 0
        let s:state.end = 1
        call SearchWarningMsg(w, flags)
    else
        let show_marks = " Mark: " . w
        if strlen(show_marks) >= &columns
            let show_marks = show_marks[0:(&columns - 6)] . " ..."
        endif

        echohl MarkWord1
        echo show_marks
        echohl None
        let s:state.end = 0
    endif

    let g:mwLastSearched = ""
endfunction

" Restore previous 'cpo' value
let &cpo = s:save_cpo

" vim: ts=4 sw=4
