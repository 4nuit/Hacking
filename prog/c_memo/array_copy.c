#include <stdlib.h>
#include <stdio.h>

int* array_copy(int t[], int size){
	int *res;
	int i;
	// Heap is not freed after exiting 
	res = (int*) malloc(size*sizeof(int));
	for (i = 0; i < size; i++){
		res[i] = t[i];
	}
	return res;
}

void main(){

	int data[5] = {1,2,3,4,5};
	int *data2 = array_copy(data,5);
	for (int i = 0; i < 5; i++){
		printf("%i\n",data2[i]);
	}
	free(data2);
	data2 = NULL;
}
