config
======
this file is config for debian system, like ubuntu or linux mint. contain gvim, dwm, dmenu, source list, 
cscope and tag create function...

why gvim?
========
gvim can set font, linespace and color support  better than vim. support alt map

why gtags?
==========
gtags have better support c++ than cscope

usage
======
1. $ source setup.sh
2. create tags cscope.file and GTAGS 
   $ cssetl "source_dir"
   tags:         create by ctags
   cscope.files: contain filelist we interest
   GPATH  GRTAGS  GTAGS: gtags file
3. open gvim
    ：A source_dir1 source_dir2 ...
     add dir to work space
     :R 
     remove all added dirs
4. vim operates
---------------
    4.1 search tag
    "alt-/" 
    4.2 search search file
    "alt-f"
   

setup.sh
========
create cscope and tags for diff directory
add also create a dict file for complete code

    csset/cssetl:
                  -o only create cscope.files\n
                     -a append create cscope.files\n
                  -s skip create cscope.files\n
                  -  exinclude dir \n
                  -k kernel mode, for create tags\n
                  +  .h file as c++ files, for create tags(default .h as c)\n
                  ++ do not remove m in kinds used for c++, fot create tags\n
               
vimrc
=====
very import for me
it contain function
* Add/remove diff directory cscope.out and tags
>:A/R directory
* grep search file in current file
> \<C-s\>
* grep search file in cscope.files
> \<M-f\> or \<Space\>f
* grep search string in cscope.file contained files
> \<M-s\> or \<Space\>s
* many map for convenient

filter.py
=========
filter out compiled file when source code contain many target or arch unused files
default all source list file is cscope.files
real compile file is obj.files
> filter.py -s cscope.files -o obj.files

will overwrite cscope.files after delete uncompiled c,c++,s,S files

    SourceFileList:cscope.files
    ObjFileList:obj.files
    Obj Type:c|cpp|s|S

