#!/bin/bash

function creat_cscope()
{
    if [ -e "cscope.files" ]; then
        rm -rf cscope.files
    fi

    echo "create cscope.files in $@"
    for arg in $@
    do
        find  ${arg}  -type f |sed  -e '/ /d' -n -e '/\(\.\(\([chmSs]\)\|\(java\)\|\(cpp\)\|\(hp\)\|\(aidl\)\|\(rc\)\|\(cc\)\|\(def\)\|\(xml\)\|\(mk\)\)\|\([Mm]akefile\)\|\(Kconfig\)\)$/p' >> cscope.files
    done

    echo "create cscope"
    cscope -bki cscope.files
}

function csset()
{
    if [ $# -eq 0 ];then
        echo "need dirname"
        return
    fi

    csclean
    creat_cscope $@

    echo "create tags"
    ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
    sed 's/\s.*$//g' tags  >  dict
    echo "create  success"
}

function cssetm()
{
    if [ $# -eq 0 ];then
        echo "need dirname"
        return
    fi

    csclean
    creat_cscope $@

    echo "create tags"
    ctags  --fields=+iaS --extra=+q  -L cscope.files
    sed 's/\s.*$//g' tags  >  dict

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
        find ${arg}  -type f | sed '/\/\.[^\.]\| \|\.o$\|\.taghl\|tags\|cscope\|\.a$/d'  >> cscope.files
    done

    echo "create tags"
    ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
    sed 's/\s.*$//g' tags  >  dict

    echo "create  success"
}

function cstag()
{
    if [ -e "cscope.files" ]; then
        echo "create cscope"
        cscope -bki cscope.files
        echo "create tags"
        ctags --c-kinds=-m --c++-kinds=-m --fields=+iaS --extra=+q  -L cscope.files
        sed 's/\s.*$//g' tags  >  dict
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
            find $arg  -type f -name "cscope.*" -o -name tags -o name dict |xargs rm -rf
        done
    fi
}
function cscleana()
{
    if [ $# -eq 0 ];then
        rm  -rf cscope* tags TAGS *.taghl dict
    else
        for arg in $@
        do
            find $arg  -type f -name "cscope.*" -o -name tags -o  -name dict -o -name "*.taghl" -o -name TAGS |xargs rm -rf
        done
    fi
}

function abs()
{
    adb shell  dmesg > dmesg
}
function abins()
{
    adb remount
    adb push ~/bin/busybox  /system/xbin
    adb shell " ./system/xbin/busybox --install   /system/xbin"
    adb shell PATH=$PATH:/data
}

