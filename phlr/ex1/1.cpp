
#define N 512
#define N_ITERATIONS 2000
#define CACHE_LINE 64
#define N_LINES 1024

#include <iostream>

void customTiling()
{ // 0.74s
    int i,j;
    double field[N][N];
    //TODO implement border checks!
    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int offset_i = 0; offset_i < N; offset_i += CACHE_LINE)
        {
            for (int offset_j = 0; offset_j < N; offset_j += N_LINES/2)
            {
                for (int curr_i = 0; curr_i < CACHE_LINE; curr_i++)
                {
                    for (int curr_j = 0; curr_j < CACHE_LINE; curr_j++)
                    {
                        i = offset_i + curr_i;
                        j = offset_j + curr_j;
                        field[i][j] = .25 * (field[i-1][j] + field[i+1][j] + field[i][j-1] + field[i][j+1]);
                    }
                }
            }
        }
    }
}

void naiveTiling()
{ // 5.85s
    int i,j;
    double field[N][N];
    
    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int offset_i = 0; offset_i < N; offset_i += CACHE_LINE)
        {
            for (int offset_j = 0; offset_j < N; offset_j += CACHE_LINE)
            {
                for (int curr_i = 0; curr_i < CACHE_LINE; curr_i++)
                {
                    for (int curr_j = 0; curr_j < CACHE_LINE; curr_j++)
                    {
                        i = offset_i + curr_i;
                        j = offset_j + curr_j;
                        field[i][j] = .25 * (field[i-1][j] + field[i+1][j] + field[i][j-1] + field[i][j+1]);
                    }
                }
            }
        }
    }
}

void naiveCProTiling()
{  // 5.94s
    
    double field[N][N];
    
    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int offset_i = 0; offset_i < N; offset_i += CACHE_LINE)
        {
            for (int offset_j = 0; offset_j < N; offset_j += CACHE_LINE)
            {
                for (int curr_i = 0; curr_i < CACHE_LINE; curr_i++)
                {
                    for (int curr_j = 0; curr_j < CACHE_LINE; curr_j++)
                    {
                        int i,j;
                        i = offset_i + curr_i;
                        j = offset_j + curr_j;
                        field[i][j] = .25 * (field[i-1][j] + field[i+1][j] + field[i][j-1] + field[i][j+1]);
                    }
                }
            }
        }
    }
}

void original()
{ // 4.50s
    double field[N][N];

    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int i = 1; i < N-1; i++)
        {
            for (int j = 1; j < N-1; j++)
            {
                field[i][j] = .25 * (field[i-1][j] + field[i+1][j] + field[i][j-1] + field[i][j+1]);
            }
        }
    }
}

void swappedLoops()
{ // 10.93s
    double field[N][N];

    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int j = 1; j < N-1; j++)
        {
            for (int i = 1; i < N-1; i++)
            {
                field[i][j] = .25 * (field[i-1][j] + field[i+1][j] + field[i][j-1] + field[i][j+1]);
            }
        }
    }
}

int main(int c, char** v)
{
    //original();
    //swappedLoops();
    naiveTiling();
    //naiveCProTiling();
    //customTiling();
}



// with normal loops 8.65
// with swapped loops 17.44
