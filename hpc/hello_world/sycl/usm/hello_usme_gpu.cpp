#include <iostream>
#include <sycl/sycl.hpp>
#include <array>

int main() {
    // SYCL queue
    sycl::queue q;

    // Input data
    std::array<char, 13> hello = {'\n', '!', 'd', 'l', 'r', 'o', 'W', ' ', 'o', 'l', 'l', 'e', 'H'};
    std::array<char, 13> host;

    // Initialize host array
    std::copy(hello.begin(), hello.end(), host.begin());

    // Allocate memory on the device using USM
    char* device = sycl::malloc_device<char>(13, q);

    if (!device) {
        std::cerr << "USM allocation failed.\n";
        return -1;
    }

    // Explicit data transfer from host to device
    q.memcpy(device, host.data(), 13 * sizeof(char)).wait();

    // Reverse the array using a SYCL kernel
    q.submit([&](sycl::handler& h) {
        h.parallel_for(sycl::range<1>(13), [=](sycl::id<1> i) {
            device[i] = hello[12 - i]; // Reverse index
        });
    }).wait();

    // Explicit data transfer from device to host
    q.memcpy(host.data(), device, 13 * sizeof(char)).wait();

    // Print the resulting array
    for (const auto& ch : host) {
        std::printf("%c", ch);
    }
    std::printf("\n");

    // Free USM device memory
    sycl::free(device, q);

    return 0;
}
