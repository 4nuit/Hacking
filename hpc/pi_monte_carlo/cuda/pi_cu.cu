#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>
#include <cuda_runtime.h>

#define BLOCK_SIZE 516
#define NB_BLOCK 258
#define N 10 //N*NB_BLOCK*BLOCK_SIZE ~ 1.07e6

__global__ void cuda_inCircle(double *d_in_circle, curandState *rng){
    int i, tid;
    double point_in_circle = 0., x = 0., y = 0.;
    //thread id global, convention par ligne / grille 2D
    tid = blockIdx.x * blockDim.x + threadIdx.x;
    curand_init(clock64(), tid, 0, &rng[tid]);

    for (i=0; i<N; i++){
        x = curand_uniform(&rng[tid]);
        y = curand_uniform(&rng[tid]);
        point_in_circle += (double)(x*x +y*y <=1);
    }
    // 1résultat / thread
    d_in_circle[tid] = (double) 4.0*point_in_circle / N;
}

int main(){
    srand(1);
    double in_circle [NB_BLOCK * BLOCK_SIZE] = {0.};
    double *d_in_circle;
    double pi = 0;

    // alloue une copie des curand cote device
    curandState *d_rng;
    cudaMalloc( (void **)&d_rng, NB_BLOCK * BLOCK_SIZE * sizeof(curandState));
    // alloue une copie des result cote device (gpu)
    cudaMalloc((void **)&d_in_circle, NB_BLOCK * BLOCK_SIZE* sizeof(double));
    cudaMemcpy(d_in_circle, in_circle, NB_BLOCK * BLOCK_SIZE * sizeof(double), cudaMemcpyHostToDevice);
    clock_t start = clock();

    //1D ( 1 argument -> automatic Idx.x), 1 block , 1 thread
    //<<<NbBlocks,NBThreads/Block>>>
    cuda_inCircle<<<NB_BLOCK,BLOCK_SIZE>>>(d_in_circle, d_rng);
    cudaDeviceSynchronize();
 
    cudaMemcpy(in_circle, d_in_circle,  NB_BLOCK * BLOCK_SIZE * sizeof(double), cudaMemcpyDeviceToHost);
    // "reduction"  = somme des resultats
    for (int i = 0; i < NB_BLOCK * BLOCK_SIZE; i++)
    {
       pi += in_circle[i];
    }
    pi /= NB_BLOCK * BLOCK_SIZE;
    clock_t end = clock();
    double total = (double) (end - start) / CLOCKS_PER_SEC;
    printf("pi = %.12f , calculated in %.3f seconds with %d block and %d threads for %d iterations/thread\n", pi, total, NB_BLOCK, BLOCK_SIZE, N*NB_BLOCK*BLOCK_SIZE);
    cudaFree(d_in_circle);
    return 0;
}