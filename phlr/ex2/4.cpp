#include <stdio.h>
#include "4.hpp"

/* 
 * Matrix-Matrix-Multiplication
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 *
 * Result:
Seconds: 4.848303
Problem Size: 512
MFLOPS: 55.367
 */
void mult(const Matrix &A, const Matrix &B, Matrix &C, int n)
{
    for (int i=0; i<n; i++)
        for (int j=0; j<n; j++)
            for (int k=0; k<n; k++)
                C[i][j] += A[i][k]*B[k][j];
}

/* 
 * Matrix-Matrix-Multiplication, tiled version
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 * (ignoring boundaries, N is multiple of TILE_SIZE)
 *
 * Result: 

TILE_SIZE = 64
Seconds: 4.020251
Problem Size: 512
MFLOPS: 66.771

TILE_SIZE = 16
Seconds: 3.128195
Problem Size: 512
MFLOPS: 85.812

TILE_SIZE = 8
Seconds: 2.488156
Problem Size: 512
MFLOPS: 107.885

TILE_SIZE = 4
Seconds: 1.820114
Problem Size: 512
MFLOPS: 147.483

 */
void tiledMult(const Matrix &A, const Matrix &B, Matrix &C, int n)
{
    for (int i=0; i<n; i+=TILE_SIZE)
        for (int j=0; j<n; j+=TILE_SIZE)
            for (int k=0; k<n; k+=TILE_SIZE)
                for (int ii=0; ii<TILE_SIZE; ii++)
                    for (int jj=0; jj<TILE_SIZE; jj++)
                        for (int kk=0; kk<TILE_SIZE; kk++)
                            C[i+ii][j+jj] += A[i+ii][k+kk]*B[k+kk][j+jj];
}


double singleRunMMM(unsigned int n, unsigned char tiled)
{
    Matrix A, B, C;
    MyTimer t;
    
    fill(A,n,1);
    fill(B,n,1);
    fill(C,n,0);
    
    t.reset();
    if (!tiled)
        mult(A, B, C, n);
    else
        tiledMult(A, B, C, n);
    return t.getSeconds();
}

void analyzeMMM(uint32 min_size, uint32 step_size, uint32 max_size)
{
    double t;
    for(unsigned int i = min_size; i<=max_size; i+=step_size)
    {
        t = (2.0*i*i*i/(1000000.0))/singleRunMMM(i, 0);
        printf("%u, %3f;\n", i, t); 
    }
}

int main(int argc, char** argv)
{
    analyzeMMM(32,32,512);
    return 0;
}



/*
 * BORING STUFF
 */
 
void fill(Matrix &A, int n, int random)
{
    for (int i=0; i<n; i++)
    {
        // memory leak! Just for demo.
        std::vector<double> *b = new std::vector<double>;
        A.push_back(*b);
        for(int j=0; j<n; j++)
        {
            if (random)
                A[i].push_back((double) rand()/(double)RAND_MAX);
            else
                A[i].push_back(0);
        }
    }
}

