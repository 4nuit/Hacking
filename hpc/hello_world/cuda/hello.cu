#include <stdio.h>
#include <stdlib.h>

__global__ void cuda_hello(){
    // wont be printed
    printf("Hello World from GPU!\n");
}

int main() {
    // 1 block , 1 thread
    cuda_hello<<<1,1>>>(); 
    printf("Hello from cpu\n");
    return 0;
}