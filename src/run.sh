#!/bin/bash
#$ chmod a+x run.sh

bison -d -o Mini_LISP.tab.c Mini_LISP.y
gcc -c -g -l.. Mini_LISP.tab.c

flex -o Mini_LISP.yy.c Mini_LISP.l
gcc -c -g -l.. Mini_LISP.yy.c

gcc -o test Mini_LISP.tab.o Mini_LISP.yy.o -ll