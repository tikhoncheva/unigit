#!/usr/bin/python
# coding: utf-8
# 
# Author: Markus Doering
# File: ia_05_01.py
#

import vigra
import numpy as np

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot

def readvid():
    '''
    read video from hdf5 file
    '''
    name = "cctv_video.h5"
    vol = vigra.readHDF5(name, 'data')
    return vol

def vid2pngs(vid, prefix="image_"):
    '''
    save video as png images
    '''
    
    # use a loop since the documentation on vigra.impex.writeSlices is unclear
    for t in range(vid.shape[2]):
        vigra.impex.writeImage(vid[...,t],"tmp/%s%03d.png" % (prefix,t,))
    
def ex1():
    '''
    solve excercise 1
    '''
    
    # number of sub-excercise
    sub = 3
    
    vol = readvid()
    
    # calculate mean and median image
    meanim = np.mean(vol,axis=2)
    medim = np.median(vol, axis=2)
    
    if sub == 2: # show mean and median image
        plot.subplot(1,2,1)
        plot.imshow(meanim.swapaxes(0,1))
        plot.gray()
        plot.title("Mean Image")
        
        plot.subplot(1,2,2)
        plot.imshow(medim.swapaxes(0,1))
        plot.gray()
        plot.title("Median Image")
            
        plot.show()
    else: # generate a video with mean / median subtracted
        # subtract 
        volmean = vol-meanim.reshape((meanim.shape[0], meanim.shape[1],1)) + 255
        volmed = vol-medim.reshape((medim.shape[0], medim.shape[1],1)) + 255
        
        # normalize by maximum of both
        totalmax = max(volmean.max(),volmed.max())
        volmean = volmean / totalmax * 255
        volmed = volmed / totalmax * 255
        
        # show the videos next to each other
        vid = np.concatenate((volmean,volmed))
        
        vid2pngs(vid)
        
        # final video generation steo is done by mencoder via bash script
        
    
if __name__ == "__main__":
    ex1()
    
