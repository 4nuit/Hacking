#include <stdio.h> 
#include <stdlib.h> 
#include <omp.h>  

int main(void) 
{ 
    // Beginning of parallel region 
    #pragma omp parallel 
    { 
        printf("Hello World... from thread = %d\n", 
               omp_get_thread_num()); 
    } 
    // Ending of parallel region 
    return 0;
}