#include <iostream>
#include <sycl/sycl.hpp>
#include <vector>

constexpr size_t N = 4;
constexpr float CONSTANT = 10.0f;

int main() {
    sycl::queue q;

    std::vector<float> host_A(N * N), host_D(N * N);
    for (size_t i = 0; i < N * N; ++i)
        host_A[i] = static_cast<float>(i);

    {
        sycl::buffer<float, 2> buf_A(host_A.data(), sycl::range<2>(N, N));
        sycl::buffer<float, 2> buf_B(sycl::range<2>(N, N));
        sycl::buffer<float, 2> buf_C(sycl::range<2>(N, N));
        sycl::buffer<float, 2> buf_D(host_D.data(), sycl::range<2>(N, N));

        // Transpose A into B
        q.submit([&](sycl::handler &h) {
            auto acc_A = buf_A.get_access<sycl::access::mode::read>(h);
            auto acc_B = buf_B.get_access<sycl::access::mode::write>(h);
            h.parallel_for(sycl::range<2>(N, N), [=](sycl::id<2> idx) {
                size_t i = idx[0], j = idx[1];
                acc_B[j][i] = acc_A[i][j];
            });
        });

        // Add CONSTANT to B, store in C
        q.submit([&](sycl::handler &h) {
            auto acc_B = buf_B.get_access<sycl::access::mode::read>(h);
            auto acc_C = buf_C.get_access<sycl::access::mode::write>(h);
            h.parallel_for(sycl::range<2>(N, N), [=](sycl::id<2> idx) {
                acc_C[idx] = acc_B[idx] + CONSTANT;
            });
        });

        // Matrix multiply C * C to produce D
        q.submit([&](sycl::handler &h) {
            auto acc_C = buf_C.get_access<sycl::access::mode::read>(h);
            auto acc_D = buf_D.get_access<sycl::access::mode::write>(h);
            h.parallel_for(sycl::range<2>(N, N), [=](sycl::id<2> idx) {
                size_t i = idx[0], j = idx[1];
                float sum = 0.0f;
                for (size_t k = 0; k < N; ++k)
                    sum += acc_C[i][k] * acc_C[k][j];
                acc_D[i][j] = sum;
            });
        });
    }

    // Print result D
    std::cout << "Matrix D:\n";
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j)
            std::cout << host_D[i * N + j] << " ";
        std::cout << "\n";
    }

    return 0;
}
