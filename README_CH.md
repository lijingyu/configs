
1.gvim 比vim有什么好处？
===================
gvim color配置更丰富，可以使用alt键，行间距，字体自定义和其他

2.编程字体选哪个？
============
目前自我感觉Microsoft Consolas 最好，Inconsolata 也不错。

3.cscope 和gtags？
================
gtags对c++的引用的支持更好

3.如何创建工程？
============
1. 在项目文件目录dir1,dir2下创建tags，GTAGS...
2. vim 中：A dir1 dir2

4.如何在项目文件目录dir1,dir2下创建tags，GTAGS？
=======
1. $ source setup.sh
2. $ cssetl dir1 dir2

5.如何只将需要的文件加载进目录，比如只看.c .cpp .java？
==============
修改setup.sh 中函数create_cscopefiles

" find  ${arg}  -type f -regextype posix-egrep \
                    -iregex '.*\/(makefile|Kconfig)' -prune -o \
                    -type f -regex '.*\.(c|h|m|s|S|java|sh|cpp|vim|hp|aidl|rc|py|cc|def|xml|mk|el|lisp|dtsi|dts|ss|y|lex|gperf|inf|dec|hal|hpp|cxx|hh|hxx|h++)"
                    
 然后执行4
 
6.gvim中添加不同的目录到当前的状态中？
============
gvim中执行
：A dir2 dir

7.删除当前状态中添加的所有目录?
=========
gvim中执行
：R
8.删除当前状态中添加的指定目录?
 =======
 不支持
 
