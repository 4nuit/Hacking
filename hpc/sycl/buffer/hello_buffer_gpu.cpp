#include <iostream>
#include <array>
#include <sycl/sycl.hpp>

int main() {
    // SYCL queue
    sycl::queue q;

    // Input data
    //std::array<char, 14> message = {'G', 'd', 'k', 'k', 'n', '\x1f', 'V', 'n', 'q', 'k', 'c', '\t', '\0', '\0'};
    std::string message = "Gdkkn\x1fVnqkc\t\0\0";
    // Create a SYCL buffer (manages data on host and device)
    {
        sycl::buffer<char, 1> buf(message.data(), sycl::range<1>(14));

        // Submit a command group to the SYCL queue
        q.submit([&](sycl::handler& h) {
            // Create an accessor for the buffer in device mode
            sycl::accessor device_acc(buf, h, sycl::write_only);

            // Kernel to increment each character
            h.parallel_for(sycl::range<1>(14), [=](sycl::id<1> i) {
                device_acc[i]++;
            });
        }); // End of kernel submission

        // Host accessor to read back results
        sycl::host_accessor host_acc(buf, sycl::read_only);
        for (auto& ch : host_acc) {
            std::cout << ch << " ";
        }
        std::cout << "\n";
    } // Buffer goes out of scope and data is synchronized to `message`.

    // Print the updated message
    for (const auto& ch : message) { // Avoid printing the trailing null character
        std::printf("%c", ch);
    }
    std::printf("\n");

    return 0;
}
