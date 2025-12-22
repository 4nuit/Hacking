#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <mpi.h>

#define N 1000000

int main(int argc, char **argv){
    
    //Init
    int numProcs, myRank;
    double x,y; 
    long totalNumTosses, numProcessTosses, totalNumberInCircle, processNumberInCircle = 0;
    double start, finish, loc_elapsed, elapsed, piEstimate;
    double PI25DT = 3.141592653589793238462643;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numProcs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);

    //The master (rank 0) broadcast
    totalNumTosses = (long) N; 
    MPI_Bcast(&totalNumTosses, 1, MPI_LONG, 0, MPI_COMM_WORLD);
    numProcessTosses = totalNumTosses / numProcs;
    //printf("%d\n", numProcessTosses);

    //Wait & block all processes until each perform the loop
    start = MPI_Wtime();
    unsigned int seed = (unsigned)time(NULL);
    srand(seed + myRank);
    for(int i=0; i<=numProcessTosses ; i++){ 
        x = (rand_r(&seed) / RAND_MAX);
        y = (rand_r(&seed) / RAND_MAX);
        if (x*x + y*y <= 1){     // reduction : 1 thread per term. 1 (x4) if P is in circle.
            processNumberInCircle += 1;
        }
    }
    // barrier: synchro avant chaque collective
    // reduction: somme Monte Carlo over all processes (1 element = per 1 process) (MPI_SUM)
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Reduce(&processNumberInCircle, &totalNumberInCircle, 1, MPI_LONG, MPI_SUM, 0, MPI_COMM_WORLD);
    
    // reduction: temps (master) = max du temps des process (le plus long) (MPI_MAX)
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Reduce(&loc_elapsed, &elapsed, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    //
    if (myRank == 0) {
        finish = MPI_Wtime();
        loc_elapsed = finish-start;
        printf("%d\n %d\n",totalNumberInCircle,totalNumTosses);
        piEstimate = (double)((double)4.0*totalNumberInCircle)/((double) totalNumTosses);
        printf("Elapsed time = %f seconds \n", elapsed);
        printf("Pi is approximately %.16f, Error is %.16f\n", piEstimate, fabs(piEstimate - PI25DT));
    }
    MPI_Finalize(); 
    return 0;
}