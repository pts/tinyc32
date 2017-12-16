.text
.globl cs_print
.type cs_print, @function
cs_print:
/* !! copy comments from hic32.nasm */
/* 000000D5  53                push ebx */
.byte 0x53
/* 000000D6  56                push esi */
.byte 0x56
/* 000000D7  57                push edi */
.byte 0x57
/* 000000D8  96                xchg eax,esi */
.byte 0x96
mov csargs_all + 12, %edi
/* 000000DF  89FA              mov edx,edi */
.byte 0x89, 0xFA
/* 000000E1  C1EA04            shr edx,byte 0x4 */
.byte 0xC1, 0xEA, 0x04
/* 000000E4  AC                lodsb */
.byte 0xAC
/* 000000E5  AA                stosb */
.byte 0xAA
test %al, %al
/* 000000E8  75FA              jnz 0xe4 */
.byte 0x75, 0xFA
/* 000000EB  9C                pushfd */
.byte 0x9C
/* 000000EC  B802000000        mov eax,0x2 */
xor %eax, %eax
inc %eax
inc %eax
/* 000000F1  31DB              xor ebx,ebx */
.byte 0x31, 0xDB
/* 000000F3  60                pushad */
.byte 0x60
push %edx
push %ebx
mov %esp, %edx
push %ebx
push %edx
push $0x22
call *(csargs_all + 8)  /* cs_intcall */
add $0x38, %esp
pop %edi
pop %esi
pop %ebx
ret
