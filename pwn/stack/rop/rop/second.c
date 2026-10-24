#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>

#define BUFSIZE 16

/*gcc -o second second.c -m32 -fno-stack-protector -no-pie -static -z,noexecstack*/

void vuln() {
  char buf[16];
  printf("Have you mastered ROP?\n");
  return gets(buf);

}


void main(int argc, char **argv){
  vuln();
}
