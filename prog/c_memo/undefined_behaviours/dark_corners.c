#include <stdio.h>

int main(void) {
	char a = ' ' * 13;
	// 2 problems
	// integer overflow
	// char sign is not detailed
	printf("%c\n",a);
	// here the result is (0x20*13)%256
	return a;
}

