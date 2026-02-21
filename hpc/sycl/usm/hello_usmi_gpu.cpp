#include <iostream>
#include <sycl/sycl.hpp>
#include <array>

int main() {
    // Create a SYCL queue
    sycl::queue q;

    // Warning: string is not device-copyable!
    // std::string hello = "\n!dlroW olleH";
    std::array<char, 14> hello = {'\n', '!', 'd', 'l', 'r', 'o', 'W', ' ', 'o', 'l', 'l', 'e', 'H', '\0'};

    // Allocate host-accessible memory (host) and shared memory (shared)
    char* host = sycl::malloc_host<char>(hello.size(), q);
    char* shared = sycl::malloc_shared<char>(hello.size(), q);

    // Check if USM allocation succeeded
    if (!host || !shared) {
        std::cerr << "USM allocation failed.\n";
        return -1;
    }

    // Initialize host memory from the input array
    std::copy(hello.begin(), hello.end(), host);

    // Submit kernel to reverse the string
    q.submit([&](sycl::handler& h) {
        h.parallel_for(sycl::range<1>(hello.size() - 1), [=](sycl::id<1> i) {
            // Host array is accessed on the device (USM)
            shared[i] = host[hello.size() - 2 - i];
        });
    }).wait(); // Ensure kernel execution completes

    // Transfer results from shared memory to host array and print
    for (std::size_t i = 0; i < hello.size() - 1; i++) {
        host[i] = shared[i];
        std::printf("%c", host[i]);
    }
    std::printf("\n");

    // Free allocated memory
    sycl::free(shared, q);
    sycl::free(host, q);

    return 0;
}
