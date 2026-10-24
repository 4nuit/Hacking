#include <stdlib.h>
#include <stdio.h>

void swap(int* pa, int* pb){
	int tmp;
	tmp = *pa;
	*pa = *pb;
	*pb = tmp;
}

void swap2(int* pa, int* pb){
	*pa ^= *pb;
	*pb ^= *pa;
	*pa ^= *pb;
}

void main(){
	int a = 2;
	int b = 3;
	printf("Start = %p : %i , %p, %i\n",&a,a,&b,b);

	swap(&a,&b);
	printf("Swap = %p : %i , %p, %i\n",&a,a,&b,b);

	swap2(&a,&b);
	printf("Swap2 = %p : %i , %p, %i\n",&a,a,&b,b);
}
