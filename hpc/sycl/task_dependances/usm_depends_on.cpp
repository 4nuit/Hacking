#include <iostream>
#include <sycl/sycl.hpp>
#include <vector>

constexpr size_t N = 4;
constexpr float CONSTANT = 10.0f;

int main() {
    sycl::queue q;
    float *A = sycl::malloc_shared<float>(N * N, q);
    float *B = sycl::malloc_shared<float>(N * N, q);
    float *C = sycl::malloc_shared<float>(N * N, q);
    float *D = sycl::malloc_shared<float>(N * N, q);

    // Initialize matrix A
    for (size_t i = 0; i < N * N; ++i)
        A[i] = static_cast<float>(i);

    // Transpose A into B
    auto e1 = q.submit([&](sycl::handler &h) {
        h.parallel_for(sycl::range<2>(N, N), [=](sycl::id<2> idx) {
            size_t i = idx[0], j = idx[1];
            B[j * N + i] = A[i * N + j];
        });
    });

    // Add CONSTANT to B, store in C
    auto e2 = q.submit([&](sycl::handler &h) {
        // Define dependance 
        h.depends_on(e1);
        h.parallel_for(sycl::range<1>(N * N), [=](sycl::id<1> i) {
            C[i] = B[i] + CONSTANT;
        });
    });

    // Matrix multiply C * C to produce D
    q.submit([&](sycl::handler &h) {
        h.depends_on(e2);
        // Define dependance
        h.parallel_for(sycl::range<2>(N, N), [=](sycl::id<2> idx) {
            size_t i = idx[0], j = idx[1];
            float sum = 0.0f;
            for (size_t k = 0; k < N; ++k)
                sum += C[i * N + k] * C[k * N + j];
            D[i * N + j] = sum;
        });
    }).wait();

    // Print result D
    std::cout << "Matrix D:\n";
    for (size_t i = 0; i < N; ++i) {
        for (size_t j = 0; j < N; ++j)
            std::cout << D[i * N + j] << " ";
        std::cout << "\n";
    }

    sycl::free(A, q);
    sycl::free(B, q);
    sycl::free(C, q);
    sycl::free(D, q);

    return 0;
}
