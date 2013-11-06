#ifndef MY_4_HPP
#define MY_4_HPP

#include <vector>
#include <cstdlib>
#include <sys/time.h>
#include <sys/resource.h>

#define TILE_SIZE 4u


/* PC specs:
 * 
 * $ getconf -a |grep CACHE
LEVEL1_ICACHE_SIZE                 65536
LEVEL1_ICACHE_ASSOC                2
LEVEL1_ICACHE_LINESIZE             64
LEVEL1_DCACHE_SIZE                 65536
LEVEL1_DCACHE_ASSOC                2
LEVEL1_DCACHE_LINESIZE             64
LEVEL2_CACHE_SIZE                  524288
LEVEL2_CACHE_ASSOC                 16
LEVEL2_CACHE_LINESIZE              64
LEVEL3_CACHE_SIZE                  6291456
LEVEL3_CACHE_ASSOC                 48
LEVEL3_CACHE_LINESIZE              64
LEVEL4_CACHE_SIZE                  0
LEVEL4_CACHE_ASSOC                 0
LEVEL4_CACHE_LINESIZE              0
 *
 */


typedef std::vector<std::vector<double> > Matrix;
typedef unsigned int uint;

inline double timevalToSeconds(const struct timeval &t)
{
    return t.tv_sec + t.tv_usec / 1000000.0;
}

/* keeps track of time */
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

void fill(Matrix &A, int n, int random=0);

#endif
