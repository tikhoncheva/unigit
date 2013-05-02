#!/usr/bin/python

from textureSynthesis_helpers import mkCostMap, verticalPathsCosts
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
    
def testVerticalPathsCosts():

    costs = numpy.asarray([[1,2,3,4],[0,0,1,0]])
    expected = numpy.asarray([[1,2,3,4],[1,1,3,3]])
    got = verticalPathsCosts(costs)
    p('expected', expected)
    p('got', got)
    assert numpy.all(got == expected)
    m = 10
    n = 5
    costs = numpy.ceil(numpy.random.rand(m,n)*10)
    cumulated = verticalPathsCosts(costs)
    ans = numpy.zeros((m,2*n+1))
    ans[:,:n] = costs
    ans[:,n+1:] = cumulated 
    p('Costs \t Cumulated Costs', ans)

if __name__ == "__main__":
    #testMkCostMap()
    testVerticalPathsCosts()

