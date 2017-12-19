#! /bin/bash --
# by pts@fazekas.hu at Tue Dec 19 02:34:25 CET 2017

IFS='
'
set -ex
cd "${0%/*}"
rm -f -- *.o libtinyc32.a
../tinyc32 -v gcc -W -Wall -Werror -Wsystem-headers -ansi -pedantic -c *.s *.c
ar cr libtinyc32.a $(ls -- *.o | grep -v '^empty[.]o$' | sort)
rm -f -- *.o
# start.s is in the parent directory, because tinyc32 -ftinyc32-multipass
# needs to edit it directly for linking.
../tinyc32 -v gcc -c ../start0.s
mv -f libtinyc32.a start0.o ../

: compile.sh OK.
