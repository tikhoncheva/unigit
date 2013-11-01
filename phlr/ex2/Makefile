CPPFLAGS=-Wall -O3 -funroll-loops 

all: 3.out 4.out

%.out: %.cpp
	g++ ${CPPFLAGS} -o $@ $<

.PHONY: all
