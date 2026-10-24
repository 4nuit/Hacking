#include <stdlib.h>

//gcc -m32 fake_lib.c -o fake_lib.so -shared -fPIC

long ptrace(int request, int pid, void *addr, void *data) {
  return 0;
}

int strcmp(const char* s1, const char* s2, int i){
  //printf("%s\n",s1);
  //printf("%s\n",s2);
  return 0;
}
