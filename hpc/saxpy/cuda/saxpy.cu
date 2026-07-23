#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <time.h>

#define BLOCK_SIZE 32
#define NB_BLOCK 16
#define n 10 // Matrix size (10x10 in this example)
#define N (n*n)

__global__ void saxpy(double *c, double *a, double *b) {
    // Grid formula
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    // Kernel only support 1D - reduction for each C coeff
    if (row < n && col < n) {
        double sum = 0.0;
        for (int k = 0; k < n; k++) {
            sum += a[row * n + k] * b[k * n + col];
        }
        c[row * n + col] = sum;
    }
}

int main() {
    double *d_c, *d_a, *d_b;
    // Set matrices as 1D blocks of threads (tab contiguous indexing)
    double *c = (double *)calloc(n * n, sizeof(double));
    double *a = (double *)malloc(n * n * sizeof(double));
    double *b = (double *)malloc(n * n * sizeof(double));

    // Initialize matrices a and b
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i * n + j] = 1.0;  // Flattened indexing
            b[i * n + j] = 2.0;
        }
    }

    // Allocate memory on the GPU
    cudaMalloc((void **)&d_a, n * n * sizeof(double));
    cudaMalloc((void **)&d_b, n * n * sizeof(double));
    cudaMalloc((void **)&d_c, n * n * sizeof(double));

    // Copy data from host to device
    cudaMemcpy(d_a, a, n * n * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, n * n * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(d_c, c, n * n * sizeof(double), cudaMemcpyHostToDevice);

    // Define grid and block sizes
    dim3 threadsPerBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 numBlocks((n + BLOCK_SIZE - 1) / BLOCK_SIZE, (n + BLOCK_SIZE - 1) / BLOCK_SIZE);

    // Print configuration
    printf("numBlocks: {%d, %d, %d}, threadsPerBlock: {%d, %d, %d}\n", numBlocks.x, numBlocks.y, numBlocks.z, threadsPerBlock.x, threadsPerBlock.y, threadsPerBlock.z);

    // Measure the computation time
    clock_t start = clock();

    // Launch kernel
    saxpy<<<numBlocks, threadsPerBlock>>>(d_c, d_a, d_b);
    cudaDeviceSynchronize();

    // Copy result back to host
    cudaMemcpy(c, d_c, n * n * sizeof(double), cudaMemcpyDeviceToHost);

    clock_t end = clock();
    double total = (double)(end - start) / CLOCKS_PER_SEC;

    // Print result matrix
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%.2f ", c[i * n + j]);
        }
        printf("\n");
        if (i >= 10) break;
    }

    printf("Time: %.3f seconds\n", total);

    // Free memory
    free(c);
    free(a);
    free(b);
    cudaFree(d_c);
    cudaFree(d_a);
    cudaFree(d_b);

    return 0;
}
