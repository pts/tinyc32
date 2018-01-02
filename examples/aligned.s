/*
 * aligned.s: Demo for aligned functions.
 *
 * $ tinyc32 gcc -Wall -o aligned1.c32 aligned.s  # Shows warning, creates unaligned output executable.
 * $ tinyc32 gcc -Wall -o aligned2.c32 -ftinyc32-align aligned.s  # Creates small and aligned output executable by calling gcc twice. In this case the output executable is even smaller than aligned1.c32.
 * $ tinyc32 gcc -Wall -o aligned3.c32 -ftinyc32-align -fno-tinyc32-multipass aligned.s  # Creates large and aligned output executable.
 */
.text
.align 128
.globl _start
_start:
ret
ret
ret
.align 128
ret
