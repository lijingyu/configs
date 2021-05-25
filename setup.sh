#!/bin/bash

INCLUD_DIRS=
EXINCLUDE_DIRS='test\|Test'
EX_START=0
KERNEL_TAGS=0
SKIP_CREATE_CSCOPE_FILES=0
ONLY_CREATE_CSCOPE_FILES=0
IGNORE_FILE='.igr'
#cscope mode or gtags mode
GTAGS_MODE=1
if [ -e "/usr/local/bin/ctags" ]; then
    CTAGS_CMD=/usr/local/bin/ctags
else
    CTAGS_CMD=/usr/bin/ctags
fi


CTAGS_PARAM_H_AS_C=" --c-kinds=-m --c++-kinds=-m --python-kinds=-i --fields=+iaS --langmap=c++:+.cu.hal,c:.c.h,java:+.aidl.kt -L cscope.files"
CTAGS_PARAM_DEF=" --c-kinds=-m --c-kinds=+m --python-kinds=-i --fields=+iaS --langmap=c++:+.cu.hal,java:+.aidl.kt --extras=+q -L cscope.files"

#export GTAGSCONF="/usr/local/share/gtags/gtags.conf"
export GTAGSFORCECPP=1
export GTAGSLABEL=native

function csset_usage()
{
    echo_msg "csset/cssetl:
                  -o only create cscope.files\n
                     -a append create cscope.files\n
                  -s skip create cscope.files\n
                  -ng use cscope mode (default use gtags)\n
                  -  exinclude dir \n
                  -k kernel mode, for create tags\n
                  -c  .h file as c files, used when all souce is c(default c++ mode)\n
                  "
}

function create_cscope()
{
    echo_msg "create cscope"
    if [ $GTAGS_MODE -eq 1 ];then
        export GTAGSFORCECPP=1
        gtags -f cscope.files
    else
        unset GTAGSFORCECPP
        cscope -bki cscope.files
    fi
}

function create_cscopefiles()
{
    if [ $APPEND_CREATE_CSCOPE_FILES -ne 1 ];then
        if [ -e "cscope.files" ]; then
            rm -rf cscope.files
        fi
    fi

    EXINCLUDE_DIRS='test\|Test'
    set_ignore "$IGNORE_FILE"
    echo_msg "create cscope.files in $@"
    echo "ignore: $EXINCLUDE_DIRS"
    for arg in $@
    do
        case "$(uname -s)" in
            "Linux")
                find  ${arg}  -type f -regextype posix-egrep \
                    -iregex '.*\/(makefile|Kconfig|CMakeLists.txt)' -prune -o \
                    -type f -regex '.*\.(c|h|m|s|S|java|sh|cpp|vim|hp|aidl|rc|py|cc|def|xml|mk|el|lisp|dtsi|dts|ss|y|lex|gperf|inf|dec|hal|hpp|cxx|hh|hxx|h++|cu|qml|kt|cmake)'\
                    |sed  -e "/[ '()]/d" -e '/\/\./d' -e 's:^\./::' |grep -v "$EXINCLUDE_DIRS" >> cscope.files;;

            "Darwin")
                find -E ${arg}  -type f \
                    -iregex '.*\/(makefile|Kconfig|CMakeLists.txt)' -prune -o \
                    -type f -regex '.*\.(c|h|m|s|S|java|sh|cpp|vim|hp|aidl|rc|py|cc|def|xml|mk|el|lisp|dtsi|dts|ss|y|lex|gperf|inf|dec|hal|hpp|cxx|hh|hxx|h++|cu|qml|kt|cmake)'\
                    |sed  -e "/[ '()]/d" -e '/\/\./d' -e 's:^\./::' |grep -v "$EXINCLUDE_DIRS" >> cscope.files;;
        esac
    done
}

function create_tags()
{
    echo_msg "create tags"
    if [ -s "cscope.files" ]; then
        if [ $KERNEL_TAGS -eq 1 ];then
            echo_msg "  KERNEL TAGS"
            exuberant "$CTAGS_PARAM"
        else
            $CTAGS_CMD $CTAGS_PARAM
        fi
    else
        echo_msg "need cscope.files"
    fi
}

function create_dict()
{
    echo_msg "create dict"
    if [ -s "tags" ]; then
        awk -F '\t' '{ print $1 }' tags | uniq >  dict
    else
        echo_msg "need tags"
    fi
}

function echo_msg()
{
    echo "$@"
}

function set_ignore()
{
    if [ -s "$1" ]; then
        for line in `cat $1`
        do
            EXINCLUDE_DIRS="$EXINCLUDE_DIRS\|$line"
        done
    fi
}

function parse_param()
{
    INCLUD_DIRS=
    EX_START=0
    KERNEL_TAGS=0
    CTAGS_PARAM=$CTAGS_PARAM_DEF
    SKIP_CREATE_CSCOPE_FILES=0
    APPEND_CREATE_CSCOPE_FILES=0
    ONLY_CREATE_CSCOPE_FILES=0
    GTAGS_MODE=1

    for arg in $@
    do
        if [ $arg == "-" ]; then
            EX_START=1
            continue
        fi

        if [ $arg == "-s" ]; then
            SKIP_CREATE_CSCOPE_FILES=1
            continue
        fi
        if [ $arg == "-ng" ]; then
            GTAGS_MODE=0
            continue
        fi
        if [ $arg == "-o" ]; then
            ONLY_CREATE_CSCOPE_FILES=1
            continue
        fi
        if [ $arg == "-a" ]; then
            APPEND_CREATE_CSCOPE_FILES=1
            continue
        fi
        if [ $arg == "-k" ]; then
            KERNEL_TAGS=1
            continue
        fi
        if [ $arg == "-c" ]; then
            CTAGS_PARAM=$CTAGS_PARAM_H_AS_C
            continue
        fi
        if [ $arg == "-h" ]; then
            csset_usage
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
        create_tags
        create_cscope
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

    if [ $SKIP_CREATE_CSCOPE_FILES -eq 0 ];then
        if [ $APPEND_CREATE_CSCOPE_FILES -eq 0 ];then
            csclean
        fi
        create_cscopefiles $@
    fi

    if [ $ONLY_CREATE_CSCOPE_FILES -eq 1 ];then
        return
    fi

    if [ "$CTAGS_PARAM" == "$CTAGS_PARAM_DEF" ]; then
        echo_msg "    c++ mode    "
    elif [ "$CTAGS_PARAM" == "$CTAGS_PARAM_H_AS_C" ]; then
        echo_msg "    c mode    "
    fi

    create_tags
    create_cscope
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

    gtags  -f cscope.files
    echo_msg "create  success"
}

function cssetl()
{
    if [ $# -eq 0 ];then
        echo_msg "need dirname"
        return
    fi

    parse_param $@
    local cur_dir=`pwd`
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

function create_objfiles()
{
    local cur_dir=`pwd`
    local work_dir=''

    for arg in $@
    do
        if [ -d $arg ];then
            cd $arg
            work_dir=`pwd`
            find . -type f -regextype posix-egrep \
                -iregex '.*\.(o|obj|class)'  |sed  -e '/ /d' -e 's:^\./::' >> $cur_dir/obj.files
            cd $cur_dir
        else
            echo_msg "$@ is not directory!!"
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
        $CTAGS_CMD --c-kinds=-m --c++-kinds=-m --fields=+iaS  -L cscope.files
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
       echo_msg "csclean dir:" `pwd`
       rm  -rf cscope* tags TAGS ncscope* dict GPATH GRTAGS  GTAGS GSYMS
       cd $cur_dir
   else
       echo_msg "$@ is not directory!!"
   fi
}

function csclean()
{
    if [ $# -eq 0 ];then
        echo_msg "csclean dir:" `pwd`
        rm  -rf cscope* tags TAGS ncscope* dict GPATH GRTAGS  GTAGS GSYMS
    else
        for arg in $@
        do
            delete_cscope_tags $arg
        done
    fi
}

# Basic regular expressions with an optional /kind-spec/ for ctags and
# the following limitations:
# - No regex modifiers
# - Use \{0,1\} instead of \?, because etags expects an unescaped ?
# - \s is not working with etags, use a space or [ \t]
# - \w works, but does not match underscores in etags
# - etags regular expressions have to match at the start of a line;
#   a ^[^#] is prepended by setup_regex unless an anchor is already present
regex_asm=(
	'/^\(ENTRY\|_GLOBAL\)(\([[:alnum:]_\\]*\)).*/\2/'
)
regex_c=(
	'/^SYSCALL_DEFINE[0-9](\([[:alnum:]_]*\).*/sys_\1/'
	'/^COMPAT_SYSCALL_DEFINE[0-9](\([[:alnum:]_]*\).*/compat_sys_\1/'
	'/^TRACE_EVENT(\([[:alnum:]_]*\).*/trace_\1/'
	'/^TRACE_EVENT(\([[:alnum:]_]*\).*/trace_\1_rcuidle/'
	'/^DEFINE_EVENT([^,)]*, *\([[:alnum:]_]*\).*/trace_\1/'
	'/^DEFINE_EVENT([^,)]*, *\([[:alnum:]_]*\).*/trace_\1_rcuidle/'
	'/^DEFINE_INSN_CACHE_OPS(\([[:alnum:]_]*\).*/get_\1_slot/'
	'/^DEFINE_INSN_CACHE_OPS(\([[:alnum:]_]*\).*/free_\1_slot/'
	'/^PAGEFLAG(\([[:alnum:]_]*\).*/Page\1/'
	'/^PAGEFLAG(\([[:alnum:]_]*\).*/SetPage\1/'
	'/^PAGEFLAG(\([[:alnum:]_]*\).*/ClearPage\1/'
	'/^TESTSETFLAG(\([[:alnum:]_]*\).*/TestSetPage\1/'
	'/^TESTPAGEFLAG(\([[:alnum:]_]*\).*/Page\1/'
	'/^SETPAGEFLAG(\([[:alnum:]_]*\).*/SetPage\1/'
	'/\<__SETPAGEFLAG(\([[:alnum:]_]*\).*/__SetPage\1/'
	'/\<TESTCLEARFLAG(\([[:alnum:]_]*\).*/TestClearPage\1/'
	'/\<__TESTCLEARFLAG(\([[:alnum:]_]*\).*/TestClearPage\1/'
	'/\<CLEARPAGEFLAG(\([[:alnum:]_]*\).*/ClearPage\1/'
	'/\<__CLEARPAGEFLAG(\([[:alnum:]_]*\).*/__ClearPage\1/'
	'/^__PAGEFLAG(\([[:alnum:]_]*\).*/__SetPage\1/'
	'/^__PAGEFLAG(\([[:alnum:]_]*\).*/__ClearPage\1/'
	'/^PAGEFLAG_FALSE(\([[:alnum:]_]*\).*/Page\1/'
	'/\<TESTSCFLAG(\([[:alnum:]_]*\).*/TestSetPage\1/'
	'/\<TESTSCFLAG(\([[:alnum:]_]*\).*/TestClearPage\1/'
	'/\<SETPAGEFLAG_NOOP(\([[:alnum:]_]*\).*/SetPage\1/'
	'/\<CLEARPAGEFLAG_NOOP(\([[:alnum:]_]*\).*/ClearPage\1/'
	'/\<__CLEARPAGEFLAG_NOOP(\([[:alnum:]_]*\).*/__ClearPage\1/'
	'/\<TESTCLEARFLAG_FALSE(\([[:alnum:]_]*\).*/TestClearPage\1/'
	'/^PAGE_MAPCOUNT_OPS(\([[:alnum:]_]*\).*/Page\1/'
	'/^PAGE_MAPCOUNT_OPS(\([[:alnum:]_]*\).*/__SetPage\1/'
	'/^PAGE_MAPCOUNT_OPS(\([[:alnum:]_]*\).*/__ClearPage\1/'
	'/^TASK_PFA_TEST([^,]*, *\([[:alnum:]_]*\))/task_\1/'
	'/^TASK_PFA_SET([^,]*, *\([[:alnum:]_]*\))/task_set_\1/'
	'/^TASK_PFA_CLEAR([^,]*, *\([[:alnum:]_]*\))/task_clear_\1/'
	'/^DEF_MMIO_\(IN\|OUT\)_[XD](\([[:alnum:]_]*\),[^)]*)/\2/'
	'/^DEBUGGER_BOILERPLATE(\([[:alnum:]_]*\))/\1/'
	'/^DEF_PCI_AC_\(\|NO\)RET(\([[:alnum:]_]*\).*/\2/'
	'/^PCI_OP_READ(\(\w*\).*[1-4])/pci_bus_read_config_\1/'
	'/^PCI_OP_WRITE(\(\w*\).*[1-4])/pci_bus_write_config_\1/'
	'/\<DEFINE_\(MUTEX\|SEMAPHORE\|SPINLOCK\)(\([[:alnum:]_]*\)/\2/v/'
	'/\<DEFINE_\(RAW_SPINLOCK\|RWLOCK\|SEQLOCK\)(\([[:alnum:]_]*\)/\2/v/'
	'/\<DECLARE_\(RWSEM\|COMPLETION\)(\([[:alnum:]_]\+\)/\2/v/'
	'/\<DECLARE_BITMAP(\([[:alnum:]_]*\)/\1/v/'
	'/\(^\|\s\)\(\|L\|H\)LIST_HEAD(\([[:alnum:]_]*\)/\3/v/'
	'/\(^\|\s\)RADIX_TREE(\([[:alnum:]_]*\)/\2/v/'
	'/\<DEFINE_PER_CPU([^,]*, *\([[:alnum:]_]*\)/\1/v/'
	'/\<DEFINE_PER_CPU_SHARED_ALIGNED([^,]*, *\([[:alnum:]_]*\)/\1/v/'
	'/\<DECLARE_WAIT_QUEUE_HEAD(\([[:alnum:]_]*\)/\1/v/'
	'/\<DECLARE_\(TASKLET\|WORK\|DELAYED_WORK\)(\([[:alnum:]_]*\)/\2/v/'
	'/\(^\s\)OFFSET(\([[:alnum:]_]*\)/\2/v/'
	'/\(^\s\)DEFINE(\([[:alnum:]_]*\)/\2/v/'
	'/\<DEFINE_HASHTABLE(\([[:alnum:]_]*\)/\1/v/'
)
regex_kconfig=(
	'/^[[:blank:]]*\(menu\|\)config[[:blank:]]\+\([[:alnum:]_]\+\)/\2/'
	'/^[[:blank:]]*\(menu\|\)config[[:blank:]]\+\([[:alnum:]_]\+\)/CONFIG_\2/'
)
setup_regex()
{
	local mode=$1 lang tmp=() r
	shift

	regex=()
	for lang; do
		case "$lang" in
		asm)       tmp=("${regex_asm[@]}") ;;
		c)         tmp=("${regex_c[@]}") ;;
		kconfig)   tmp=("${regex_kconfig[@]}") ;;
		esac
		for r in "${tmp[@]}"; do
			if test "$mode" = "exuberant"; then
				regex[${#regex[@]}]="--regex-$lang=${r}b"
			else
				# Remove ctags /kind-spec/
				case "$r" in
				/*/*/?/)${#regex[@]}
					r=${r%?/}
				esac
				# Prepend ^[^#] unless already anchored
				case "$r" in
				/^*) ;;
				*)
					r="/^[^#]*${r#/}"
				esac
				regex[${#regex[@]}]="--regex=$r"
			fi
		done
	done
}

exuberant()
{
	setup_regex exuberant asm c
	$CTAGS_CMD  $1                                      \
	-I __initdata,__exitdata,__initconst,			\
	-I __initdata_memblock					\
	-I __refdata,__attribute,__maybe_unused,__always_unused \
	-I __acquires,__releases,__deprecated			\
	-I __read_mostly,__aligned,____cacheline_aligned        \
	-I ____cacheline_aligned_in_smp                         \
	-I __cacheline_aligned,__cacheline_aligned_in_smp	\
	-I ____cacheline_internodealigned_in_smp                \
	-I __used,__packed,__packed2__,__must_check,__must_hold	\
	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL   \
	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
	-I static,const						\
	"${regex[@]}"
}

