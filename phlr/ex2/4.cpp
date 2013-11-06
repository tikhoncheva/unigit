#include <stdio.h>
#include "4.hpp"

/* 
 * Matrix-Matrix-Multiplication
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 */
void mult(const Matrix &A, const Matrix &B, Matrix &C, uint n)
{
    for (uint i=0; i<n; i++)
        for (uint j=0; j<n; j++)
            for (uint k=0; k<n; k++)
                C[i][j] += A[i][k]*B[k][j];
}

/* 
 * Matrix-Matrix-Multiplication, tiled version
 * FLOP = 2 per iteration * N^3 iterations = 2*N^3
 * (ignoring boundaries, N is multiple of TILE_SIZE)
 */
void tiledMult(const Matrix &A, const Matrix &B, Matrix &C, uint n, uint tile_size=TILE_SIZE)
{
    for (uint i=0; i<n; i+=tile_size)
        for (uint j=0; j<n; j+=tile_size)
            for (uint k=0; k<n; k+=tile_size)
                for (uint ii=0; ii<tile_size; ii++)
                    for (uint jj=0; jj<tile_size; jj++)
                        for (uint kk=0; kk<tile_size; kk++)
                            C[i+ii][j+jj] += A[i+ii][k+kk]*B[k+kk][j+jj];
}

/*
 * Gauss-Seidel algorithm
 * FLOP = 4*n_iter*(n-2)^2
 */
void gaussSeidel(Matrix &A, uint n_iter, uint n_size)
{ 
    for (uint k = 0; k < n_iter; k++)
    {
        for (uint i = 1; i < n_size-1; i++)
        {
            for (uint j = 1; j < n_size-1; j++)
            {
                A[i][j] = .25 * (A[i-1][j] + A[i+1][j] + A[i][j-1] + A[i][j+1]);
            }
        }
    }
}

/* one timed matrix-matrix-multiplication */
double singleRunMMM(uint n, unsigned char tiled, uint tile_size=TILE_SIZE)
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
        tiledMult(A, B, C, n, tile_size);
    return t.getSeconds();
}

/* one timed gauss-seidel */
double singleRunGS(uint n_iter, uint n_size)
{
    Matrix A;
    MyTimer t;
    
    fill(A,n_size,1);

    t.reset();
    gaussSeidel(A, n_iter, n_size);
    return t.getSeconds();
}

/* run many matrix-matrix-multiplications, print result */
void analyzeMMM(uint min_size, uint step_size, uint max_size)
{
    double t;
    for(uint i = min_size; i<=max_size; i+=step_size)
    {
        t = (2.0*i*i*i/(1000000.0))/singleRunMMM(i, 0);
        printf("%u, %3f;\n", i, t); 
    }
}

/* run many matrix-matrix-multiplications, print result */
void analyzeTiledMMM(uint n, uint min_size, uint step_size, uint max_size)
{
    double t;
    for(uint i = min_size; i<=max_size; i*=step_size)
    {
        t = (2.0*n*n*n/(1000000.0))/singleRunMMM(n, 1, i);
        printf("%u, %3f;\n", i, t); 
    }
}

/* run many gauss-seidels */
void analyzeGS(uint k, uint min_size, uint step_size, uint max_size)
{
    double t;
    for(uint i = min_size; i<=max_size; i+=step_size)
    {
        t = (4.0*(i-2)*(i-2)*k/(1000000.0))/singleRunGS(k, i);
        printf("%u, %3f;\n", i, t); 
    }
}

int main(int argc, char** argv)
{
    /* with a 65k L1-cache, 524k L2-cache and 6.3M L3-Cache we would expect 
     * things to get worse at 65k = 8*3*n^2, 524k = 8*3*n^2 and 6.3M = 8*3*n^2,
     * i.e. n=20 resp. n=50 resp. n=512
     */
    //analyzeMMM(4096,1,4096);
    
    //analyzeTiledMMM(2048, 1, 2, 1024);
    
    analyzeGS(1000, 2048, 128, 4096);
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

