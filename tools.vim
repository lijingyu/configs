function! MdFuncParam()
    normal G

    let endfuncParam_line=search(')\s*\n^{', 'b')
    while endfuncParam_line > 0
        normal %
        let startfuncParam_line = line('.')
        if startfuncParam_line != endfuncParam_line
            exe startfuncParam_line . "," . endfuncParam_line ."j"
        endif
        let endfuncParam_line=search(')\s*\n^{', 'b')
    endwhile

endfunction

function! Replace()
    let start_pos = search('^#ifdef\s\+CFW_MULTI_SIM')
    while start_pos > 0
        normal %
        if match(getline('.'), '#else') < 0
            let else_flag = 0
        else
            let else_flag = 1
        endif

        let else_pos = line('.')

        if else_flag > 0
            normal %
            exe else_pos . "," . line('.') . "d"
            exe start_pos . "d"
        else
            exe line('.') . "d"
            exe start_pos . "d"
        endif
    let start_pos = search('^#ifdef\s\+CFW_MULTI_SIM')
    endwhile
endfunction

function! Replace_ndef()
    let start_pos = search('^#if\s\+0')
    while start_pos > 0
        normal %
        if match(getline('.'), '#else') < 0
            let else_flag = 0
        else
            let else_flag = 1
        endif

        let else_pos = line('.')

        if else_flag > 0
            normal %
            exe line('.') . "d"
            exe start_pos . "," . else_pos . "d"
        else
            exe start_pos . ",". line('.') . "d"
        endif
        let start_pos = search('^#if\s\+0')
    endwhile
endfunction


function! Colors_test()
    let colornum=1
    while colornum < 255
        echo  "hi Normal ctermbg=". colornum
        exe "hi Normal ctermbg=". colornum
        let colornum = colornum+1
    endwhile
    colorscheme cterm

endfunction


function! Count_Var_size()
     "delete other code without bss part
    let bss_start = search('^.bss')
    let bss_start = search('^ .bss')
    exec "1,". bss_start . 'd'

    let bss_end = search('^[^ ]')
    let bss_end -= 1
    exec bss_end . ',$d'

    let line_cur = 1
    let totle_line = line('$')

    exec '%s/^.\+fff8//g'

    while line_cur < totle_line
       let base = str2nr(split(getline(line_cur), ' ')[0], 16)
       let next_base = str2nr(split(getline(line_cur+1), ' ')[0], 16)
       let tag_size=(next_base - base)
       let tag_size_k=tag_size/1024

       exec line_cur . 's/^/       /'
       exec line_cur . 's/^/\=tag_size_k/'
       exec line_cur .'s/ /k/'

       exec line_cur .'s/  \zs/\=tag_size/'
       let line_cur += 1
   endwhile
    
   exe '$d'
endfunction

