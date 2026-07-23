#include <iostream>
#include <omp.h> 

int main(void) 
{
    // Beginning of parallel region 
    #pragma omp parallel 
    { 
        std::cout << "Hello World... from thread = " << omp_get_thread_num() << std::endl;
        //std::cout << std::format("{} {}!", "Hello World ... from thread = ", omp_get_thread_num()) << std::endl;
        //std::cout << "Hello World... from thread = " << omp_get_thread_num() << " \n";
    } 
    // Ending of parallel region 

    return 0;
}           