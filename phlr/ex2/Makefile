CPPFLAGS=-Wall -O3 -funroll-loops 

all: 3.out 4.out

%.out: %.cpp
	g++ ${CPPFLAGS} -o $@ $<

clean:
	rm *.out 2>/dev/null

.PHONY: all clean
