
#define N 512
#define N_ITERATIONS 2000
#define CACHE_LINE 64
#define N_LINES (24576/64)
#define MIN(a,b) ((a)<(b)?(a):(b))

int main(int c, char** v)
{ // 0.74s
    int i,j,maxi,maxj,mini,minj;
    double field[N][N];
    //TODO implement border checks!
    for (int k = 0; k < N_ITERATIONS; k++)
    {
        for (int offset_i = 0; offset_i < N; offset_i += CACHE_LINE)
        {
            // start with element 1 if we are on left border
            mini = offset_i ? 0 : 1;
            
            // don't go over right border
            maxi = MIN(CACHE_LINE, N-offset_i) - mini;
            
            for (int offset_j = 0; offset_j < N; offset_j += N_LINES/2)
            {
                minj = offset_j ? 0 : 1;
                maxj = MIN(CACHE_LINE, N-offset_j) - minj;
                for (int curr_i = mini; curr_i < maxi; curr_i++)
                {
                    for (int curr_j = minj; curr_j < maxj; curr_j++)
                    {
                        i = offset_i + curr_i;
                        j = offset_j + curr_j;
                        field[i][j] = .25 * (field[i-1][j] + 
                                             field[i+1][j] + 
                                             field[i][j-1] + 
                                             field[i][j+1]);
                    }
                }
            }
        }
    }
}


