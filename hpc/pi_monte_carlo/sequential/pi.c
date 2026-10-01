#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define N 1000000

int main(){
    srand(1);
    int in_circle = 0;
    double pi, x, y;
    clock_t start = clock();

    for(int i=0; i<=N; i++){
        x = ((double)rand() / RAND_MAX) ;
        y = ((double)rand() / RAND_MAX) ;
        printf("%2f\n %2f\n", x, y);
        if (x*x+y*y <=1 ){
            in_circle += 1;
        }
    }

    pi = (4.0 * in_circle/ N);
    clock_t end = clock();
    double total = (double) (end - start) / CLOCKS_PER_SEC;
    printf("Points in circle: %d / %d\n",in_circle, N);
    printf("pi = %.12f , calculated in %.3f seconds\n", pi, total);

    return 0;
}