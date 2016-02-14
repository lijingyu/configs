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

function! Get_Var_size()
    let tmpsymbolfile="/tmp/rda_globle_var_symbol_" .getpid() . ".txt"
    let tmp_var_file="/tmp/rda_globle_var_".getpid() . ".txt"
    execute "silent! !rm -rf  /tmp/rda_globle_var*"
    execute "silent! !rm -rf  rda_globle_var*"

    normal gg

    "copy  Common symbol
    let line_start = search('Common symbol       size', 'e')
    let line_start += 2
    exe line_start
    let line_end = search('^\s*$', '')

    exe line_start . "," . line_end . "w! " . tmpsymbolfile
    echo  "start ". line_start
    echo  "end ". line_end

    "copy globle_var in data or bss
    normal gg

    while 1
        let line_cur = search('^\s*\.data\.\|^\s*\.bss\.', 'We')
        if line_cur == 0
            break
        endif
        if len(split(getline('.'), ' ')) < 2
            exe 'j'
        endif
        silent exe '.w! >> ' . tmp_var_file
    endwhile

    "edit  tmpsymbolfile
    let &bufhidden = "unload"
    silent! exe "e " . tmpsymbolfile
    exe 'g/^\s/normal -1J'
    exe '%s/\s\S*$//'
    exe "w!"

    let &bufhidden = "unload"
    "edit  global var file
    silent! exe "e " . tmp_var_file
    exe '%s/\(\S*\)\s*\(\S*\)\s*\(\S*\)/\1 \2/g'
    silent! exe "r " . tmpsymbolfile
    "rm tmp file
    execute "silent! !rm -rf " . tmpsymbolfile

    let line_cur = 1
    let totle_line = line('$')
    while line_cur < totle_line
       let tag_size = str2nr(split(getline(line_cur), '\s\+')[1], 16)
       let tag_size_k=tag_size/1024
       exec line_cur . 's/^/   /'
       exec line_cur .'s/^/\=tag_size/'
       exec line_cur . 's/^/   /'
       exec line_cur . 's/^/\=tag_size_k/'
       exec line_cur .'s/ /k/'

       let line_cur += 1
    endwhile

    exe "w!"
    exe "silent! !cp " . tmp_var_file . " rda_globle_var.txt"

    let &bufhidden = "unload"
    execute "silent! !rm -rf " . tmp_var_file
    exe 'e  rda_globle_var.txt'
endfunction

function! Modem_Get_Var_size()
    normal gg
    let line_cur = 1
    let totle_line = line('$')

    "check sencond item is addr or size
    if stridx(split(getline(line_cur), '\s\+')[1], "0x") >= 0
        let num_is_size = 1
    else
        let num_is_size = 0
    endif

    while line_cur <= totle_line
        if (num_is_size == 1)
            let tag_size = str2nr(split(getline(line_cur), '\s\+')[1], 16)
            let tag_size_k=tag_size/1024
        else
            if line_cur == totle_line
                exe '$d'
                break
            endif

            let base = str2nr(split(getline(line_cur), '\s\+')[1], 16)
            let next_base = str2nr(split(getline(line_cur+1), '\s\+')[1], 16)
            let tag_size=(next_base - base)
            let tag_size_k=tag_size/1024
        endif
        exec line_cur . 's/^/   /'
        exec line_cur .'s/^/\=tag_size/'
        exec line_cur . 's/^/   /'
        exec line_cur . 's/^/\=tag_size_k/'
        exec line_cur .'s/ /k/'

        let line_cur += 1

    endwhile
    exe "w!"
endfunction
