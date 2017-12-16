__attribute__((regparm(3))) void cs_print(const char *msg);

void _start() {
  cs_print("Hello, World!\r\n");
}
