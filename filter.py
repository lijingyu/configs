#!/usr/bin/env python
import os
import sys
import getopt
import re

File_SourceList = "cscope.files"
File_ObjList = "obj.files"
FilterSourceType = "c|cpp|s|S"
IgnDir = False

def parseParam(argv):
    global File_SourceList, File_ObjList, FilterSourceType, IgnDir
    try:
        opts, args = getopt.getopt(sys.argv[1:], "s:o:t:ih")
        for op, value in opts:
            if op == "-s":
                File_SourceList = value
            elif op == "-o":
                File_ObjList = value
            elif op == "-t":
                FilterSourceType = value
            elif op == "-i":
                IgnDir = True
            elif op == "-h":
                usage()
                sys.exit(0)
    except Exception,e:
        usage()
        sys.exit(0)


def usage():
    print("filter.py V1.0:\n\
            usage:\n\
            filter compiled files, only for FilterSourceType in File_SourceList, others will ignore\n\
            -s File_SourceList\n\
            -o File_ObjList\n\
            -t FilterSourceType \n\
            -i Match filename, file path is not necessary\n\
            ")

def Filter(FileSource, FileObj, TypesPattern, IgDir):
    if os.path.exists(FileSource) and os.path.exists(FileObj):
        oldFilSource = FileSource + '_'
        os.rename(FileSource, oldFilSource)
        SourFd = open(oldFilSource, 'r')
        ObjFd = open(FileObj, 'r')
        NewFd = open(FileSource, 'w')
    else:
        print('File_SourceList or Objs is not exists')
        return
    
    ObjFiles = ObjFd.read()
    ObjFd.close()
    
    delete_count = 0
    while(True):
        savline = line = SourFd.readline()
        if line == '':
            break

        # match type
        line = line.replace('+','\+')
        if re.search("\.("+TypesPattern +")", line):
            if IgDir:
               line = os.path.basename(line)
            if re.search(line[:(line.rindex('.'))] + '\.', ObjFiles):
                NewFd.write(savline)
            else:
                delete_count += 1
                continue
        else:
            NewFd.write(savline)

    SourFd.close()
    os.remove(oldFilSource)
    NewFd.close()
    print("delete uncompile file: " + str(delete_count))

if __name__ == "__main__":
    parseParam(sys.argv[1:])
    print("File_SourceList:" + File_SourceList + "\n"\
            "File_ObjList:" + File_ObjList + "\n"\
            "Filter Source Type:" + FilterSourceType + "\n")

    Filter(File_SourceList, File_ObjList, FilterSourceType, IgnDir)

