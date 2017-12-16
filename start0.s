.text
.align 0x100
.globl _start0
.type _start0, @function
_start0:  /* Code must start with this. */
/* 00000000  B8FE4CCD21        mov eax,0x21cd4cfe */
.byte 0xb8, 0xfe, 0x4c, 0xcd, 0x21
cld

.include "reloc.s"

/* !! copy comments from hic32.nasm */
lea 8(%esp), %esi
lea csargs_all, %edi
mov 16(%esp), %eax
shr $4, %eax
stos %eax, %es:(%edi)  /* .byte 0xab */   /* stosd */
mov $8, %ecx
rep movsd
mov 40(%esp), %esi
add $4, %esi
/* mov csargs_all + 9 * 4, %edi */  /* Not needed, already correct. */
mov $14, %ecx
rep movsd

call _start
ret

.set  csargs_all_size, 23 * 4
.comm csargs_all, csargs_all_size, 1
