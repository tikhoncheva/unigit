#ifndef MY_4_HPP
#define MY_4_HPP

#include <vector>
#include <cstdlib>
#include <sys/time.h>
#include <sys/resource.h>

#define TILE_SIZE 4


typedef std::vector<std::vector<double> > Matrix;
typedef unsigned int uint32;

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

void fill(Matrix &A, int n, int random=0);

#endif
