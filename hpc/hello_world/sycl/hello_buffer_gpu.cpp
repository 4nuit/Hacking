#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;

int main(){
    queue q;
    char hello[14] = "Gdkkn\x1fVnqkc\t";
    std::array<char, 14> message;
    for (int i=0; i<14; i++){
        message[i] = hello[i];
    }
    //Create buffer
    {   //buf scope
        buffer buf(message);

        //Commande
        q.submit([&](handler &h){
            //Create device accessor (device pointer/instance of buf)
            accessor device_acc(buf,h);
            //Kernel
            h.parallel_for(14, [=](id<1> i){
                device_acc[i]++ ;
            });
        });

        //Create host accessor
        host_accessor host_acc(buf);
        for (int i=0; i<14; i++){
            std::cout << host_acc[i] << " ";
        }
        std::cout << "\n";
    }

    //Updating message now buf is destroyed
    for (int i=0; i<13; i++){
        printf("%c",message[i]);
    }
    return 0;
}