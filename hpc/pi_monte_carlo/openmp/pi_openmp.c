#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

#define N 1000000 //1e6 cause invalide predicate
//#define T 10

int main(){
    srand(time(NULL)); // Changed from rand(1) to rand(time(NULL))
    int in_circle = 0;
    double pi, x, y;
    //clock_t start = clock();
    printf("%d\n",N);
    
    // Initialisation de result (sans reduction)
    //#pragma omp parallel shared(nb_threads)
    //#pragma omp master
    //nb_threads = omp_get_num_threads();
    //fprintf(stdout, "Nb threads: %d\n", nb_threads);
    //uint64_t* result = (uint64_t*)malloc(sizeof(uint64_t) * nb_threads);
    //for (i = 0; i < nb_threads; ++i) {
    //    result[i] = 0;
    //}

    // fork-join model: master is forked into T threads (D&C), join on implicit barrier
    // private: x,y are local variables indépendantes -> mémoire privée (autant que possible)
    // reduction: sum over all threads (operation: lvalue/type)
    //#pragma omp parallel shared(result) firstprivate(n_test, x, y)
    #pragma omp parallel for private(x,y) reduction(+:in_circle) //num_threads(T)
    //#pragma omp for schedule(static)
        for(int i=0; i<=N; i++){ 
            x = ((double)rand() / RAND_MAX);
            y = ((double)rand() / RAND_MAX);
            if (x*x + y*y <= 1){     // reduction : 1 thread per term. 1 (x4) if P is in circle.
                in_circle += 1;
            }
            //sans la pragma reduction
            //int tid = omp_get_thread_num();
            //result[tid] = local_res;

        }
    //for (i = 0; i < nb_threads; ++i) {
    //   pi += result[i];
    //}
    pi = (4.0 * in_circle) /  N;
    //clock_t end = clock();
    //double total = (double)(end - start) / CLOCKS_PER_SEC;
    //printf("Points in circle: %d / %d\n",in_circle, N);
    printf("pi = %.12f\n", pi);

    return 0;
}
