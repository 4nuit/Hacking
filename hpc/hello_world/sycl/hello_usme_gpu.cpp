#include <iostream>
#include <sycl/sycl.hpp>
#include <array>

using namespace sycl;

//Explicit Data Movement in USM
int main() {
    queue q;
    std::array<char, 13> hello = {'\n', '!', 'd', 'l', 'r', 'o', 'W', ' ', 'o', 'l', 'l', 'e', 'H'};
    std::array<char, 13> host;

    for (int i = 0; i < 13; i++) {
        host[i] = hello[i];
    }

    //cast cpp - device only
    char* device = malloc_device<char>(13, q);

    //Commande
    q.submit([&](handler& h) {
        h.memcpy(device, host.data(), 13 * sizeof(char));
    });
    //Synchronizing
    q.wait();

    //Commande
    q.submit([&](handler& h) {
        //Kernel
        h.parallel_for(13, [=](id<1> i) {
            device[i] = hello[12 - i];
        });
    });
    //Synchronizing
    q.wait();

    // Command
    q.submit([&](handler& h) {
        h.memcpy(host.data(), device, 13 * sizeof(char));
    });
    //Synchronizing
    q.wait();

    for (int i = 0; i < 13; i++) {
        printf("%c", host[i]);
    }

    free(device, q);
    return 0;
}
