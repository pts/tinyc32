tinyc32: A tiny C library and toolchain for writing Syslinux COM32R executables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
tinyc32 is a tiny C library and some Python scripts for Unix for creating
tiny Syslinux COM32R executables (.c32 files). tinyc32 calls GCC with the
appropriate flags, which calls GNU ld with the appropriate flags. The COM32R
executables created by tinyc32 are tiny (as little as 178 bytes for
hello-world), because they contain very little overhead.

Dependencies:

* A Unix system, preferably Linux.
* GCC (with the -m32 flag for producing i386 code)
* Works with GCC 4.8.4. (Not tested with Clang.)
* GNU ld from GNU Binutils.
* Python 2.4, 2.5, 2.6 or 2.7.
* (A Syslinux installation or sources are not needed.)

Typical example of how tiny the overhead added by tinyc32: a hello-world
(examples/hello_golden.c32) is 178 bytes, which includes the message of
15 bytes.

Documentation of the COMBOOT (and COM32R) ABI:
http://www.syslinux.org/doc/comboot.txt

Example compilation (run it without the leading $):

  $ ./tinyc32 gcc -o examples/hello.c32 examples/hello_main.c

Example usage in your syslinux.cfg:

  label hello
  kernel hello.c32
  append your  example args

With the default settings, tinyc32 tries to create the smallest possible
executable. This includes passing -Os and -falign-functions (etc.) to GCC.
If you specify an -O... flag other than -Os (recommended for fast code:
-O2), then tinyc32 won't get in your way, e.g. it won't specify any
memory alignment flags to GCC.

tinyc32 has been tested with Syslinux 4.07.

FAQ
~~~
Q1. How does tinyc32 work?
""""""""""""""""""""""""""
A tricky part is the generation of position-independent code, which is
needed because .c32 files can be loaded by Syslinux to any address. `gcc
-fPIC' doesn't work well for extern variables (see
https://stackoverflow.com/q/47846650/97248), so tinyc32 does a regular
compilation and linking, dumping the relocations with `-Wl,-q', and for each
R_386_32 relocation it finds, it adds an `add [dword ebx +
...], ebx' instruction (6 bytes, of which 4 bytes is the address) to the
startup code, which does the relocation at runtime. Because of these
additions, tinyc32 does another round of gcc compilation, which does at least
and assembler invocation for the newly added instructions.

Q2. Can the executables created by tinyc32 be compressed?
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Theoretically yes, but UPX (http://upx.sf.net/) and other on-the-fly
compressors don't recognize the .c32 format yet.

Q3. How can I try the .c32 I'm developing?
""""""""""""""""""""""""""""""""""""""""""
You can use QEMU on an i386 or amd64 system. On Ubuntu, install it as:

  $ sudo apt-get install qemu-system-x86

Get the mtools tool for copying files into FAT filesystem images:

  $ curl -OL https://github.com/pts/tinyc32/releases/download/helper/mtools
  $ chmod 755 mtools

Get the Syslinux image liigboot_empty.img . It contains a FAT12 filesystem
with Syslinux 4.07 on it. Get it like this

  $ curl -OL https://github.com/pts/tinyc32/releases/download/helper/c32try_empty.img.gz
  $ gzip -cd <c32try_empty.img.gz >c32try.img

Get an example .c32 file to run:

  $ curl -O https://raw.githubusercontent.com/pts/tinyc32/master/examples/hello_golden.c32

Copy your .c32 file you want to try to a.c32 onto the image:

  $ ./mtools -c mcopy -i c32try.img hello_golden.c32 ::a.c32

Run the QEMU emulator in the GUI:

  $ qemu-system-i386 -m 4 -hda c32try.img -machine accel=kvm -net none

It should display something like this in a new black window:

  SeaBIOS (...)
  Booting from Hard Disk...
  MR 0x...
  Hello, World!
  boot: _

The ``Hello, World!'' is the output of the hello_golden.c32, so it has
succeeded. You can run it again by pressing <A> and <Enter>.

If QEMU doesn't start up, drop the `-machine accel=kvm' flag and try again.

Exit from QEMU by closing the black window or presing on Ctrl-<C> in the
terminal window you have started it in.

__END__
