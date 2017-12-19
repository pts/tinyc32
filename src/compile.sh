#! /bin/bash --
# by pts@fazekas.hu at Tue Dec 19 02:34:25 CET 2017

IFS='
'
set -ex
cd "${0%/*}"
rm -f -- *.o libtinyc32.a
../tinyc32 -v gcc -W -Wall -Werror -Wsystem-headers -ansi -pedantic -c *.s *.c
ar cr libtinyc32.a $(ls -- *.o | grep -v '^empty[.]o$' |
    grep -v '^start0[.]o$' | sort)
mv -f libtinyc32.a start0.o ../
rm -f -- *.o

: compile.sh OK.
