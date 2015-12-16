#!/bin/bash

function creat_cscope()
{
    if [ -e "cscope.files" ]; then
        rm -rf cscope.files
    fi

    echo "create cscope.files in $@"
    for arg in $@
    do
        find  ${arg}  -type f |sed  -e '/ /d' -e 's:^\./::' -n -e '/\(\.\(\([chmSs]\)\|\(java\)\|\(cpp\)\|\(hp\)\|\(aidl\)\|\(rc\)\|\(cc\)\|\(def\)\|\(xml\)\|\(mk\)\)\|\([Mm]akefile\)\|\(Kconfig\)\)$/p' >> cscope.files
    done

    echo "create cscope"
    cscope -bki cscope.files
}

function create_tags()
{
    echo "create tags"
    if [ -s "cscope.files" ]; then
        ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
    else
        echo "need cscope.files"
    fi
}

function create_dict()
{
    echo "create dict"
    if [ -s "tags" ]; then
        sed 's/\s.*$//g' tags | uniq >  dict
    else
        echo "need tags"
    fi
}

function csset()
{
    if [ $# -eq 0 ];then
        echo "need dirname"
        return
    fi

    csclean
    creat_cscope $@

    create_tags
    create_dict
    echo "create  success"
}

function csseta()
{
    if [ $# -eq 0 ];then
        echo "need dirname"
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

    echo "create  success"
}

function cstag()
{
    if [ -e "cscope.files" ]; then
        echo "create cscope"
        cscope -bki cscope.files
        echo "create tags"
        ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
        sed 's/\s.*$//g' tags | uniq >  dict
    else
        echo "no cscope.files"
    fi
}

function csclean()
{
    if [ $# -eq 0 ];then
        rm  -rf cscope* tags TAGS ncscope* dict
    else
        for arg in $@
        do
            find $arg  -type f -name "cscope.*" -o -name tags -o -name dict |xargs rm -rf
        done
    fi
}
function cscleana()
{
    if [ $# -eq 0 ];then
        rm  -rf cscope* tags TAGS dict
    else
        for arg in $@
        do
            find $arg  -type f -name "cscope.*" -o -name tags -o  -name dict -o -name TAGS |xargs rm -rf
        done
    fi
}

function abins()
{
    adb remount
    adb push ~/bin/busybox  /system/xbin
    adb shell " ./system/xbin/busybox --install   /system/xbin"
    adb shell PATH=$PATH:/data
}

