#include <stdio.h>

int passed_by_value(int a){
	int square = a*a;
	return square;
}

//a is a value
//int* ptr = &a
//we defined a pointer by using "int* " but a=int *ptr (value pointed by ptr)
int passed_by_value2(int* ptr){
	//a is a value - ptr its pointer
	int a = *ptr;
	int square = a*a;
	return square;
}

void passed_by_reference(int *a){
	//a is a pointer
	//we directly access to a and change its value *a by its square
	*a = (*a)*(*a);
}

int main(){
	int a = 3;
	int b = passed_by_value(a);
	printf("a = %d, b = %d \n",a,b);

	int c = passed_by_value2(&a); //int *ptr = &a; => ptr === &a ; int *ptr == a;
	printf("a = %d, c = %d \n",a,c);

	passed_by_reference(&a);
        printf("a is now %d \n",a);
	return 0;
}
