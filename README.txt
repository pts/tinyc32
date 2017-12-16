tinyc32: A tiny C library and toolchain for writing SYSLINUX COM32R executables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
tinyc32 is a tiny C library and some Python scripts for Unix to make
tiny SYSLINUX COM32R executables (.c32 files). tinyc32 calls GCC with the
appropriate flags, which calls GNU ld with the appropriate flags. The COM32R
executables created by tinyc32 are tiny, because they contain very little
overhead.

Dependencies:

* A Unix system, preferably Linux.
* GCC (with the -m32 flag for producing i386 code)
* Works with GCC 4.8.4. (Not tested with Clang.)
* GNU Binutils (ld, objdump, objcopy).
* Bash.
* Python 2.4, 2.5, 2.6, 2.7.
* (A SYSLINUX installation or sources are not needed.)

Typical example of how tiny the overhead added by tinyc32: a hello-world
(examples/hello_golden.c32) is 162 bytes, which includes the message of
15 bytes.

Documentation of the COMBOOT (and COM32R) ABI:
http://www.syslinux.org/doc/comboot.txt

Example compilation (run it without the leading $):

  $ ./tinyc32 gcc -o examples/hello.c32 examples/hello_main.c

Example usage in your syslinux.cfg:

  label hello
  kernel hello.c32
  append your  example args

tinyc32 has been tested with SYSLINUX 4.07.

How does tinyc32 work?
~~~~~~~~~~~~~~~~~~~~~~
A tricky part is the generation of position-independent code, which is
needed because .c32 files can be loaded by SYSLINUX to any address. `gcc
-fPIC' doesn't work well for extern variables (see
https://stackoverflow.com/q/47846650/97248), so tinyc32 does a regular
compilation and linking, dumping the relocations with `-Wl,-q', and for each
R_386_32 relocation it finds, it adds an `add [dword ebx +
...], ebx' instruction (6 bytes, of which 4 bytes is the address) to the
startup code, which does the relocation at runtime. Because of these
additions, tinyc32 does another round of gcc compilation, which does at least
and assembler invocation for the newly added instructions.

__END__
