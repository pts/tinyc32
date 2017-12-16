.text
.globl cs_putc
.type cs_putc, @function
cs_putc:
/* !! copy comments from hic32.nasm */
xchg %eax, %edx
mov $2, %ah
pushfl
pushal
xor %eax, %eax
push %eax
push %eax
mov %esp, %edx
push %eax
push %edx
push $0x21
call *(csargs_all + 8)  /* cs_intcall */
add $0x38, %esp
ret

