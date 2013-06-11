#!/usr/bin/python2
# coding: utf-8
# 
# Author: Markus Doering
# File: ia_07_01.py
#

import vigra
import numpy as np

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot

    
def ex3():
    '''
    solve excercise 3
    '''
    
    xs = np.linspace(0,5)
    
    
    plot.hold(True)
    ys1 = .05*xs+3.28
    ys2 = -1.71*xs+7.51
    ys3 = -3.83*xs+14.08
    cost = .75*xs
    
    #plot line constraints
    plot.plot(xs,ys1,'r')
    plot.plot(xs,ys2,'m')
    plot.plot(xs,ys3,'b')
    
    # plot integer constraints
    plot.plot(xs,0*xs,'k')
    plot.plot(0*xs,np.linspace(0,5),'k')
    
    valid_x = [0,0,0,0,1,1,1,1,2,2,2,2,3,3,3]
    valid_y = [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2]
    plot.plot(valid_x,valid_y,'kx')
    
    # plot target vector
    plot.plot(xs,cost, 'g', linewidth=3)
    
    # mark solution
    ilp, = plot.plot([3,],[2,],'ro', markersize=12)
    lp, = plot.plot([14.08/3.83,], [0,], 'bo', markersize=12)
    rlp, = plot.plot([3,],[0,],'go', markersize=12)
    
    
    
    plot.axis([-1, 5, -1, 5])
    plot.legend([ilp,lp,rlp],['ILP solution', 'LP solution', 'rounded LP solution'])
    plot.grid()
    plot.show()
    
if __name__ == "__main__":
    ex3()
    
