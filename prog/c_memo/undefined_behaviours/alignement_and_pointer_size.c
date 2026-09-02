#include <stdio.h>

//a S struc has size 5
struct S {
  int i;
  char c;
} s;

int main(void) {
	//s point to an address containing an int + a char (5 bytes)
	//s is padded depending on the compiler
	//s is a 8-bytes struct on GCC & LLVM on x64
	printf("s is %x and has size %d\n",s,sizeof(&s));
}
