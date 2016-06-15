#!/bin/bash

function creat_cscope()
{
    if [ -e "cscope.files" ]; then
        rm -rf cscope.files
    fi

    echo_msg "create cscope.files in $@"
    for arg in $@
    do
        find  ${arg}  -type f |sed  -e '/ /d' -e 's:^\./::' -n -e '/\(\.\(\([chmSs]\)\|\(java\)\|\(cpp\)\|\(hp\)\|\(aidl\)\|\(rc\)\|\(cc\)\|\(def\)\|\(xml\)\|\(mk\)\)\|\([Mm]akefile\)\|\(Kconfig\)\)$/p' >> cscope.files
    done

    echo_msg "create cscope"
    cscope -bki cscope.files
}

function create_tags()
{
    echo_msg "create tags"
    if [ -s "cscope.files" ]; then
        ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
    else
        echo_msg "need cscope.files"
    fi
}

function create_dict()
{
    echo_msg "create dict"
    if [ -s "tags" ]; then
        sed 's/\s.*$//g' tags | uniq >  dict
    else
        echo_msg "need tags"
    fi
}

function echo_msg()
{
    echo $@
}

function csset()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    csclean
    creat_cscope $@

    create_tags
    create_dict
    echo_msg "create  success"
}

function cssetl()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    cur_dir=`pwd`
    for arg in $@
    do
        if [ -d "$arg" ]; then
            echo_msg "---- $arg ----"
            cd $arg
            csset .
            cd $cur_dir
        else
            echo_msg "===ERROR! $arg is not dir====" 
            return
        fi
    done
}

function csseta()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    csclean
    creat_cscope $@

    rm  -rf cscope.files tags TAGS

    for arg in $@
    do
        find ${arg}  -type f | sed '/\/\.[^\.]\| \|\.o$\|tags\|cscope\|\.a$/d'  >> cscope.files
    done

    create_tags
    create_dict

    echo_msg "create  success"
}

function cstag()
{
    if [ -e "cscope.files" ]; then
        echo_msg "create cscope"
        cscope -bki cscope.files
        echo_msg "create tags"
        ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
        sed 's/\s.*$//g' tags | uniq >  dict
    else
        echo_msg "no cscope.files"
    fi
}

function delete_cscope_tags()
{
   if [ -d $@ ];then
       cur_dir=`pwd`
       cd $@
       rm  -rf cscope* tags TAGS ncscope* dict
       cd $cur_dir
   else
       echo_msg "$@ is not directory!!"
   fi
}

function csclean()
{
    if [ $# -eq 0 ];then
        rm  -rf cscope* tags TAGS ncscope* dict
    else
        for arg in $@
        do
            delete_cscope_tags $arg
        done
    fi
}

