#!/bin/bash

INCLUD_DIRS=
EXINCLUDE_DIRS='xxxxxx'
EX_START=0
CTAGS_PARAM_DEF=" --c-kinds=-m --c++-kinds=-m --python-kinds=-i --fields=+iaS --extra=+q -L cscope.files"
CTAGS_PARAM_CPP=" --python-kinds=-i --fields=+iaS --extra=+q -L cscope.files"
CTAGS_PARAM=$CTAGS_PARAM_DEF

function create_cscope()
{
    echo_msg "create cscope"
    cscope -bki cscope.files
}

function create_cscopefiles()
{
    if [ -e "cscope.files" ]; then
        rm -rf cscope.files
    fi

    echo_msg "create cscope.files in $@"
    for arg in $@
    do
        case "$(uname -s)" in
            "Linux")
                find  ${arg}  -type f -regextype posix-egrep \
                    -iregex '.*\/(makefile|Kconfig)' -prune -o \
                    -regex '.*\.(c|h|m|s|S|java|sh|cpp|vim|hp|aidl|rc|py|cc|def|xml|mk|el|lisp|dtsi|dts)'\
                    |sed  -e '/ /d' -e 's:^\./::' |grep -v "$EXINCLUDE_DIRS" >> cscope.files;;

            "Darwin")
                echo "Darwin";;
        esac
    done
}

function create_tags()
{
    echo_msg "create tags"
    if [ -s "cscope.files" ]; then
        ctags $CTAGS_PARAM
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

function parse_param()
{
    INCLUD_DIRS=
    EXINCLUDE_DIRS='xxxxxx'
    EX_START=0
    CTAGS_PARAM=$CTAGS_PARAM_DEF

    for arg in $@
    do
        if [ $arg == "-" ]; then
            EX_START=1
            continue
        fi
        if [ $arg == "++" ]; then
            CTAGS_PARAM=$CTAGS_PARAM_CPP
            continue
        fi
        if [ $EX_START -eq 1 ];then
            EXINCLUDE_DIRS="$EXINCLUDE_DIRS\|$arg"
        else
            INCLUD_DIRS="$INCLUD_DIRS $arg"
        fi
    done
}

# create tags cscope in current dir
function me()
{
    if [ -e "cscope.files" ]; then
        create_cscope
        create_tags
        create_dict
        echo_msg "create  success"
    else
        echo_msg "no cscope.files"
    fi
}

# create tags, cscope in current dir
# prarmeter is dirs
function exe_process()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    csclean

    create_cscopefiles $@
    create_cscope
    create_tags
    create_dict
    echo_msg "create  success"
}

function csset()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    parse_param $@
    exe_process $INCLUD_DIRS
}

function cssetg()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    create_cscopefiles $@

    gtags -f cscope.files
    echo_msg "create  success"
}

function cssetl()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    parse_param $@
    cur_dir=`pwd`
    for arg in $INCLUD_DIRS
    do
        if [ -d "$arg" ]; then
            echo_msg "---- $arg ----"
            cd $arg
            exe_process .
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
    create_cscopefiles $@
    create_cscope

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
       rm  -rf cscope* tags TAGS ncscope* dict GPATH GRTAGS  GTAGS
       cd $cur_dir
   else
       echo_msg "$@ is not directory!!"
   fi
}

function csclean()
{
    if [ $# -eq 0 ];then
        rm  -rf cscope* tags TAGS ncscope* dict GPATH GRTAGS  GTAGS
    else
        for arg in $@
        do
            delete_cscope_tags $arg
        done
    fi
}

