#include <iostream>
#include <vector>
#include <cstdlib>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdio.h>

#define TILE_SIZE 4

typedef std::vector<std::vector<double> > Matrix;

inline double timevalToSeconds(const struct timeval &t)
{
    return t.tv_sec + t.tv_usec / 1000000.0;
}
    

/* keeps track of time, no security checks */
class MyTimer
{
public:

    MyTimer()
    {
        this->reset();
    }

    void reset() 
    {
        this->fill();
        this->old_tv = this->tv;
    }
    
    double getSeconds()
    {
        this->fill();
        return timevalToSeconds(this->tv) - timevalToSeconds(this->old_tv);
    }

private:

    struct timeval tv, old_tv;

    void fill()
    {
        struct rusage usage;
        if (getrusage(RUSAGE_SELF, &usage))
            exit(1);
        this->tv = usage.ru_utime;
    }
};

void fill(Matrix &A, int n, int random=0)
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


void singleRun(unsigned char tiled)
{
    double time_s;
    Matrix A, B, C;
    MyTimer t;
    
    int n = 512;
    
    fill(A,n,1);
    fill(B,n,1);
    fill(C,n,0);
    
    t.reset();
    if (!tiled)
        mult(A, B, C, n);
    else
        tiledMult(A, B, C, n);
    time_s = t.getSeconds();
    
    printf("Seconds: %.6f\n", time_s);
    printf("Problem Size: %d\n", n);
    printf("MFLOPS: %.3f\n", 2*n*n*n/(time_s*1e6));
}

int main(int argc, char** argv)
{
    singleRun(1);
    return 0;
}

