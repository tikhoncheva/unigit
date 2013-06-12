#!/usr/bin/python2
# coding: utf-8
# 
# Author: Markus Doering
# File: ia_07_03.py
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
    
    fig = plot.figure(1, figsize=(10,10))
    
    
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
    
    # mark solutions
    ilp_sol = (3,2)
    ilp, = plot.plot(ilp_sol[0], ilp_sol[1],'ro', markersize=7)
    print("ILP: solution={}, gain = {}".format(ilp_sol, 4*ilp_sol[0] + 3*ilp_sol[1]))
    
    xlp = (7.51-3.28)/(0.05+1.71)
    lp_sol = (xlp, -1.71*xlp+7.51)
    lp, = plot.plot(lp_sol[0],lp_sol[1], 'bo', markersize=7)
    print("LP: solution={}, gain = {}".format(lp_sol, 4*lp_sol[0] + 3*lp_sol[1]))
    
    rlp_sol = (2,3)
    rlp, = plot.plot(rlp_sol[0], rlp_sol[1],'go', markersize=7)
    print("rounded LP: solution={} gain = {}".format(rlp_sol, 4*rlp_sol[0] + 3*rlp_sol[1]))

    # adjust plot
    plot.axis([-1, 5, -1, 5])
    plot.legend([ilp,lp,rlp],['ILP solution', 'LP solution', 'rounded LP solution'])
    plot.grid()
    plot.show()
    
if __name__ == "__main__":
    ex3()
    
