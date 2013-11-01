#include <iostream>
#include <vector>
#include <cstdlib>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>

#define N 512
#define TILE_SIZE 64
typedef std::vector<std::vector<double> > Matrix;

void fill(Matrix &A, int random=0)
{
    for (int i=0; i<N; i++)
    {
        // memory leak! Just for demo.
        std::vector<double> *b = new std::vector<double>;
        A.push_back(*b);
        for(int j=0; j<N; j++)
        {
            if (random)
                A[i].push_back((double) rand()/(double)RAND_MAX);
            else
                A[i].push_back(0);
        }
    }
}


/* 
 * Matrix-Matrix-Multiplication
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 */
void mult(const Matrix &A, const Matrix &B, Matrix &C)
{
    for (int i=0; i<N; i++)
        for (int j=0; j<N; j++)
            for (int k=0; k<N; k++)
                C[i][j] += A[i][k]*B[k][j];
}

/* 
 * Matrix-Matrix-Multiplication, tiled version
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 * (ignoring boundaries, N is multiple of TILE_SIZE)
 */
void tiledMult(const Matrix &A, const Matrix &B, Matrix &C)
{
    for (int i=0; i<N; i++)
        for (int j=0; j<N; j++)
            for (int k=0; k<N; k++)
                C[i][j] += A[i][k]*B[k][j];
}


int main(int argc, char** argv)
{
    struct rusage usage;
    struct timeval s, t;
    double time_ms;
    Matrix A, B, C;
    
    fill(A,1);
    fill(B,1);
    fill(C,0);
    
    if (getrusage(RUSAGE_SELF, &usage))
        return 1;
    s = usage.ru_utime;
    
    mult(A, B, C);
    
    if (getrusage(RUSAGE_SELF, &usage))
        return 2;
    t = usage.ru_utime;
    
    time_ms = t.tv_sec*1000.0 + t.tv_usec / 1000.0;
    time_ms -= s.tv_sec*1000.0 + s.tv_usec / 1000.0;
    printf("Seconds: %.6f\n", time_ms/1000);
    printf("Problem Size: %d\n", N);
    printf("MFLOPS: %.3f\n", 2*N*N*N/(time_ms*1000));
    
    return 0;
}





