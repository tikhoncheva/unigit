from textureSynthesis_helpers import mkCostMap
import numpy
from vigra.impex import readImage, writeImage


import matplotlib 
matplotlib.use("Qt4Agg")
from mpl_toolkits.mplot3d import Axes3D 
from matplotlib import pyplot as plot

def showimg(x):
    x = x.astype(numpy.uint8)
    x = x.swapaxes(0,1)
    plot.imshow(x)

def p(s,a):
    print('---------------')
    print(s)
    print(a)
    print('---------------\n')


def testMkCostMap():
    X = readImage('circ.png')
    Y = X
    Y = numpy.roll(Y,20,axis=0)
    Y = numpy.roll(Y,10,axis=1)
    
    D = mkCostMap(X,Y)
    
    plot.subplot(2,3,1)
    showimg(X)

    plot.subplot(2,3,2)
    showimg(Y)

    plot.subplot(2,3,3)
    showimg(D)
    plot.gray()
    
    plot.show()

if __name__ == "__main__":
    testMkCostMap()


