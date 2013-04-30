from textureSynthesis_helpers import mkCostMap
import numpy

def p(s,a):
    print('---------------')
    print(s)
    print(a)
    print('---------------\n')


if __name__ == "__main__":
    x = numpy.asarray([[[2,3,4],[7,8,7]],[[1,5,2], [7,3,4]]]).astype(numpy.float32)
    y = x * 0.5

    z = mkCostMap(x,y)


