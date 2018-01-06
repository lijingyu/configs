#!/usr/bin/env python
import os
import sys
import getopt
import re

SourceFileList = ""
ObjFileList = ""
ObjType = ""

def parseParam(argv):
    global SourceFileList, ObjFileList, ObjType 
    opts, args = getopt.getopt(sys.argv[1:], "s:o:t:")
    for op, value in opts:
        if op == "-s":
            SourceFileList = value
        elif op == "-o":
            ObjFileList = value
        elif op == "-t":
            ObjType = value
        else:
            usage()
            sys.exit()


def usage():
    print("filter.py V1.0:\n\
            usage:\n\
            filter compiled files, only for ObjType in SourceFileList, others will ignore\n\
            -s SourceFileList\n\
            -o ObjFileList\n\
            -f ObjType (.class,.o)\n\
            ")


def Filter(FileSource, FileObj, TypesPattern):
    if os.path.exists(FileSource) and os.path.exists(FileObj):
        Fs = open(FileSource, 'r')
        Fo = open(FileObj, 'r')
        Fout = open("out.files", 'w')
    else:
        print('SourceFileList or Objs is not exists')
        return
    
    ObjFiles = Fo.read()
    Fo.close()
    
    while(True):
        line = Fs.readline()
        if line == '':
            break

        if re.search("\."+TypesPattern, line):
            print(line[:line.rindex('.')+1])
            if re.search(line[:(line.rindex('.') + 1)], ObjFiles):
                Fout.write(line)
            else:
                continue

        else:
            Fout.write(line)

    Fs.close()

if __name__ == "__main__":
    parseParam(sys.argv[1:])
    print("SourceFileList:" + SourceFileList + "\n"\
            "ObjFileList:" + ObjFileList + "\n"\
            "Obj Type:" + ObjType + "\n")

    Filter(SourceFileList, ObjFileList, ObjType) 

