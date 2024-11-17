#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;

//Implicit Data Movement in USM
int main(){
    queue q;
    char hello[14] = "\n!dlroW olleH";
    //cast cpp
    char *host = malloc_host<char>(14,q);
    char *shared = malloc_shared<char>(14,q);
    //only malloc_device is device-accessible only
    //Initializing host array
    for (int i=0; i<14; i++){
        host[i] = hello[i];
    }

    //Commande
    q.submit([&](handler &h){
        //Kernel
        h.parallel_for(13, [=](id<1> i){
            //Host array is accessed on device (USM)
            shared[i] = host[12-i];
        });
    });
    //Synchronizing
    q.wait();

    for (int i=0; i<13; i++){
        //Shared array is accessed on host (USM)
        host[i] = shared[i];
        printf("%c",host[i]);
    }
    free(shared,q);
    free(host,q);
    return 0;
}