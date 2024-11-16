#include <stdio.h>

int main(void) {
	char a = 0;
	short int b = 0;
	//char is 1 byte, short int is 2 bytes
	//a+b is padded to a sizeof int = 4 bytes
	//but padding may alter a+b 's size
	//depending on padding shot int may be greater than int
	printf("%d %d %d\n",sizeof(a),sizeof(b),sizeof(a+b));
	return sizeof(b) == sizeof(a+b);
}
