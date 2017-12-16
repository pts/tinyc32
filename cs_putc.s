.text
.globl cs_putc
.type cs_putc, @function
cs_putc:

/* Prepare the input `struct com32sys_t' upside down.
 */
xchg %eax, %edx  /* Input of cs_putc is in al, needed in com32sys_t.dl */
mov $2, %ah  /* Will be saved to com32sys_t.ah */
pushfl  /* Fill com32sys_t.eflags . */
pushal  /* Fill com32sys_t.edi .. .eax . */
xor %eax, %eax
push %eax  /* Fill com32sys_t.es and .ds with 0 . */
push %eax  /* Fill com32sys_t.gs and .fs with 0 . */

mov %esp, %edx
push %eax   /* Push arg 3 of cs_intcall: NULL. */
push %edx   /* Push arg 2 of cs_intcall: the input com32sys_t. */
push $0x21  /* Push arg 1 of cs_intcall: interrupt number. */
call *(csargs_all + 8)  /* Call cs_intcall. */
add $0x38, %esp  /* Remove cs_intcall's argumens and the com32sys_t. */
ret
