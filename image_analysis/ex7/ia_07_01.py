#!/usr/bin/python2
# coding: utf-8
# 
# Author: Markus Doering
# File: ia_07_01.py
#

import vigra
import numpy as np
from scipy.signal import convolve2d
from scipy.stats import norm

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot
from matplotlib.image import imread

nImg = 4

def rgb2gray(rgb):
    '''
    convert from RGB to grayscale
    http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
    '''
    return .299*rgb[:,:,0] + .587*rgb[:,:,1] + .114*rgb[:,:,2]

def getRealWorldImages():
    '''
    read real world images
    '''
    return [rgb2gray(imread("real%d.jpg" % (i,))) for i in range(1,nImg+1)] 
    
def gradient(im, direction='x'):
    '''
    compute the image gradient with filter [-1,1] in the specified direction
    '''
    
    filt = np.ones((2,1))
    filt[0,0] = -1
    
    if direction == 'y': 
        # first axis is vertical, i.e. y, so the filter is fine
        pass
    elif direction == 'x': 
        # transpose the filter to horizontal direction
        filt = filt.transpose()
    else:
        raise ValueError("unknown axis {}".format(direction))

    return convolve2d(im, filt, mode='same')
        
        
def myHist(im):
    '''
    compute histogram with bin centers rather than bin edges 
    and fit a gaussian to the data
    '''
    bins, bounds = np.histogram(im, bins=40, range=(-255,255), density=True)
    
    bincenters = [(bounds[i]+bounds[i+1])/2.0 for i in range(len(bounds)-1)]
    
    mu = im.mean()
    s = im.var()
    
    gaussianfit = norm.pdf(bincenters, loc=mu, scale=np.sqrt(s))
    
    return (bincenters, bins, gaussianfit)

    
def ex1():
    '''
    solve excercise 1
    '''
    
    plot.hold(True)
    
    imgs = getRealWorldImages()
    
    # compute the gradients in x and y direction separately
    xgrads = [(gradient(img, direction='x')) for img in imgs]
    ygrads = [(gradient(img, direction='y')) for img in imgs]
    

    for img, xgrad, ygrad, k in zip(imgs, xgrads, ygrads, range(len(imgs))):
        # show image
        plot.subplot(3, nImg, k+1)
        plot.imshow(img)
        plot.gray()
        plot.title('Original Image')
        
        # show histogram for x gradient
        plot.subplot(3, nImg, k+nImg+1)
        xbincenters, xbins, xgauss = myHist(xgrad)
        plot.semilogy(xbincenters,xbins, 'b')
        plot.semilogy(xbincenters,xgauss, 'r--')
        plot.legend(['histogram', 'fitted normal dist.'], loc='lower center')
        plot.title('histogram of gradient in x-direction')
        plot.axis([-260,260,1e-50,1])
        
        # show histogram for y gradient
        plot.subplot(3, nImg, k+2*nImg+1)
        ybincenters, ybins, ygauss = myHist(ygrad)
        plot.semilogy(ybincenters,ybins, 'b')
        plot.semilogy(ybincenters,ygauss, 'r--')
        plot.legend(['histogram', 'fitted normal dist.'], loc='lower center')
        plot.title('histogram of gradient in y-direction')
        plot.axis([-260,260,1e-50,1])
        
    plot.show()
    
if __name__ == "__main__":
    ex1()
    
