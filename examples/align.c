#include <tinyc32.h>

__attribute__((aligned(256))) char msg[] = "MSG";

void *_start() {
  cs_print("Align.\r\n");
  return msg;
}
