#ifndef _TINYC32_H
#define _TINYC32_H 1

#if !defined(__linux) || !defined(__i386)
#error This is for Linux i386 source code only.
#endif

#if defined(__cplusplus)
#error C++ not supported yet.
#endif

#ifdef __GNUG__
#define NULL __null
#else   /* G++ */
#ifndef __cplusplus
#define NULL ((void *)0)
#else   /* C++ */
#define NULL 0
#endif  /* C++ */
#endif  /* G++ */

/* The first three arguments in EAX, EDX, ECX; the rest on the stack. */
#define __rp3 __attribute__((regparm(3)))

#define __TINYC32_STATIC_ASSERT(name, expr_true) struct __StaticAssert##name { \
    int StaticAssert##name : (expr_true); }

typedef char int8_t;
__TINYC32_STATIC_ASSERT(SizeofInt8T, sizeof(int8_t) == 1);
typedef short int16_t;
__TINYC32_STATIC_ASSERT(SizeofInt16T, sizeof(int16_t) == 2);
typedef int int32_t;
__TINYC32_STATIC_ASSERT(SizeofInt32T, sizeof(int32_t) == 4);
__extension__ typedef long long int64_t;  /* No need for __extension__, why? */
__TINYC32_STATIC_ASSERT(SizeofInt64T, sizeof(int64_t) == 8);

typedef unsigned char uint8_t;
__TINYC32_STATIC_ASSERT(SizeofUint8T, sizeof(uint8_t) == 1);
typedef unsigned short uint16_t;
__TINYC32_STATIC_ASSERT(SizeofUint16T, sizeof(uint16_t) == 2);
typedef unsigned int uint32_t;
__TINYC32_STATIC_ASSERT(SizeofUint32T, sizeof(uint32_t) == 4);
__extension__ typedef unsigned long long uint64_t;  /* No need for __extension__, why? */
__TINYC32_STATIC_ASSERT(SizeofUint64T, sizeof(uint64_t) == 8);

typedef unsigned size_t;
typedef int ssize_t;
typedef int ptrdiff_t;
typedef int uintptr_t;

typedef union {
  uint32_t l;
  uint16_t w[2];
  uint8_t  b[4];
} reg32_t;

typedef struct {
  uint16_t gs;                  /* Offset  0 */
  uint16_t fs;                  /* Offset  2 */
  uint16_t es;                  /* Offset  4 */
  uint16_t ds;                  /* Offset  6 */

  reg32_t edi;                  /* Offset  8 */
  reg32_t esi;                  /* Offset 12 */
  reg32_t ebp;                  /* Offset 16 */
  reg32_t _unused_esp;          /* Offset 20 */
  reg32_t ebx;                  /* Offset 24 */
  reg32_t edx;                  /* Offset 28 */
  reg32_t ecx;                  /* Offset 32 */
  reg32_t eax;                  /* Offset 36 */

  reg32_t eflags;               /* Offset 40 */
} com32sys_t;

struct _DIR_;
#define DIRENT_NAME_MAX 255
struct dirent {
    uint32_t d_ino;
    uint32_t d_off;
    uint16_t d_reclen;
    uint16_t d_type;
    char d_name[DIRENT_NAME_MAX + 1];
};

struct com32_filedata {
  size_t size;      /* File size */
  int blocklg2;     /* log2(block size) */
  uint16_t handle;  /* File handle */
};

extern struct csargs_all {
  uint32_t cs_bounce_seg;
  /* csargs_copy: */
  char *cs_cmdline;  /* Tends to have a trailing space, e.g. "quiet ". */
  __attribute__((regparm(0))) void (*cs_intcall)(uint8_t, const com32sys_t *, com32sys_t *);
  char *cs_bounce;
  uint32_t cs_bounce_size;
  __attribute__((regparm(0))) void (*cs_farcall)(uint32_t, const com32sys_t *, com32sys_t *);
  __attribute__((regparm(0))) int (*cs_cfarcall)(uint32_t, const void *, uint32_t);
  uint32_t cs_memsize;
  const char *cs_name;  /* Example: "hello.c32". */
  /* pmargs_copy: */
  __attribute__((regparm(3))) void *(*lmalloc)(size_t);
  __attribute__((regparm(3))) void (*lfree)(void *);
  __attribute__((regparm(3))) int (*open_file)(const char *, struct com32_filedata *);
  __attribute__((regparm(3))) size_t (*read_file)(uint16_t *, void *, size_t);
  __attribute__((regparm(3))) void (*close_file)(uint16_t);
  __attribute__((regparm(3))) struct _DIR_ *(*opendir)(const char *);
  __attribute__((regparm(3))) struct dirent *(*readdir)(struct _DIR_ *);
  __attribute__((regparm(3))) int (*closedir)(struct _DIR_ *);
  __attribute__((regparm(3))) void (*idle)(void);
  __attribute__((regparm(3))) void (*reset_idle)(void);
  __attribute__((regparm(3))) int (*chdir)(const char *);
  __attribute__((regparm(3))) char *(*getcwd)(char *, size_t);

  /* Should be "const volatile", but gcc miscompiles that sometimes */
  volatile uint32_t *jiffies;
  volatile uint32_t *ms_timer;
} csargs_all;

__attribute__((regparm(3))) void cs_putc(char c);
/* To print a newline, print "\r\n".
 * WARNING: don't try to print long strings:
 * If strlen(msg) > 65535, then it's undefined behavior.
 */
__attribute__((regparm(3))) void cs_print(const char *msg);

static __inline__ __attribute__((regparm(3))) void *memset(void *s, char c, size_t n) {
  void *res;
  uint32_t edi_out, ecx_out;
  __asm__ __volatile__ (
      "push %%edi\n"
      "rep stosb\n"
      "pop %%eax"
      : "=a" (res), "=D" (edi_out), "=c" (ecx_out)
      : "0" (c), "1" (s), "2" (n)
      : "memory");
  return res;
}

/* Like memset, but doesn't return anything. Needs less memory. */
static __inline__ __attribute__((regparm(3))) void memset_void(void *s, char c, size_t n) {
  uint32_t edi_out, ecx_out;
  __asm__ __volatile__ (
      "rep stosb"
      : "=D" (edi_out), "=c" (ecx_out)
      : "a" (c), "0" (s), "1" (n)
      : "memory");
}

#endif  /* _XTINY_H */
