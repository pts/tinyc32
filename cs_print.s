.text
.globl cs_print
.type cs_print, @function
/* WARNING: don't try to print long strings:
 * If strlen(msg) > 65535, then it's undefined behavior.
 */
cs_print:  /* Expects msg in eax. */

/* Save some registers because the System V ABI for i386 needs it
 * (http://wiki.osdev.org/System_V_ABI#i386).
 */
push %ebx
push %esi
push %edi

/* 000000D8  96                xchg eax,esi */
.byte 0x96
mov csargs_all + 12, %edi  /* cs_bounce. */
/* 000000DF  89FA              mov edx,edi */
.byte 0x89, 0xFA
/* 000000E1  C1EA04            shr edx,byte 0x4 */
.byte 0xC1, 0xEA, 0x04  /* edx will be copied to com32sys_t.es . */

/* Copy input string to cs_bounce. */
/* 000000E4  AC                lodsb */
.byte 0xAC
/* 000000E5  AA                stosb */
.byte 0xAA
test %al, %al
/* 000000E8  75FA              jnz 0xe4 */
.byte 0x75, 0xFA

/* Prepare the input `struct com32sys_t' upside down.
 */
pushfl  /* Fill com32sys_t.eflags . */
xor %eax, %eax
inc %eax
inc %eax  /* Set eax to 2, will be saved to com32sys_t.ax . */
xor %ebx, %ebx
pushal  /* Fill com32sys_t.edi .. .eax . */
push %edx  /* Fill com32sys_t.es with the segment of msg, and .ds with 0 . */
push %ebx  /* Fill com32sys_t.gs and .fs with 0 . */

mov %esp, %edx
push %ebx   /* Push arg 3 of cs_intcall: NULL. */
push %edx   /* Push arg 2 of cs_intcall: the input com32sys_t. */
push $0x22  /* Push arg 1 of cs_intcall: interrupt number. */
call *(csargs_all + 8)  /* Call cs_intcall. */
add $0x38, %esp  /* Remove cs_intcall's argumens and the com32sys_t. */

/* Restore registered saved for the System V ABI for i386.
 */
pop %edi
pop %esi
pop %ebx
ret
