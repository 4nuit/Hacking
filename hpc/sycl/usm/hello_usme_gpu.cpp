#include <iostream>
#include <sycl/sycl.hpp>
#include <array>

int main() {
    // SYCL queue
    sycl::queue q;

    // Input data
    // Warning: string is not device-copyable!
    // std::string host = "\n!dlroW olleH";
    std::array<char, 13> hello = {'\n', '!', 'd', 'l', 'r', 'o', 'W', ' ', 'o', 'l', 'l', 'e', 'H'};

    // Allocate memory on the device using USM
    // device is located on device and accessible on device only
    char* device = sycl::malloc_device<char>(13, q);

    if (!device) {
        std::cerr << "USM allocation failed.\n";
        return -1;
    }

    // Explicit data transfer from host to device
    q.memcpy(device, hello.data(), 13 * sizeof(char)).wait();

    // Reverse the array using a SYCL kernel
    q.submit([&](sycl::handler& h) {
        h.parallel_for(sycl::range<1>(13), [=](sycl::id<1> i) {
            device[i] = hello[12 - i]; // Reverse index
        });
    }).wait();

    // Explicit data transfer from device to host
    q.memcpy(hello.data(), device, 13 * sizeof(char)).wait();

    // Print the resulting array
    for (const auto& ch : hello) {
        std::printf("%c", ch);
    }
    std::printf("\n");

    // Free USM device memory
    sycl::free(device, q);

    return 0;
}
