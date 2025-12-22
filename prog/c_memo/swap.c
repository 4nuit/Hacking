#include <stdlib.h>
#include <stdio.h>

void swap(int* pa, int* pb){
	int tmp;
	tmp = *pa;
	*pa = *pb;
	*pb = tmp;
}

void main(){
	int a = 2;
	int b = 3;
	swap(&a,&b);
	printf("%i %i\n",a,b);
}
