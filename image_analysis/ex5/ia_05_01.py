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

from pprint import pprint as pp

def readvid():
    name = "cctv_video.h5"
    vol = vigra.readHDF5(name, 'data')
    return vol

def vid2pngs(vid, prefix="image_"):
    for t in range(vid.shape[2]):
        vigra.impex.writeImage(vid[...,t],"tmp/%s%03d.png" % (prefix,t,))
    
def ex1():
    vol = readvid()
    meanim = np.mean(vol,axis=2)
    medim = np.median(vol, axis=2)
    '''
    plot.subplot(1,2,1)
    plot.imshow(meanim.swapaxes(0,1))
    plot.gray()
    plot.title("Mean Image")
    
    plot.subplot(1,2,2)
    plot.imshow(medim.swapaxes(0,1))
    plot.gray()
    plot.title("Median Image")
        
    plot.show()
    '''
    
    volmean = vol-meanim.reshape((meanim.shape[0], meanim.shape[1],1)) + 255
    volmed = vol-medim.reshape((medim.shape[0], medim.shape[1],1)) + 255
    
    volmean = volmean / max(volmean.max(),volmed.max()) * 255
    volmed = volmed / max(volmean.max(),volmed.max()) * 255
    
    vid = np.concatenate((volmean,volmed))
    
    vid2pngs(vid)
    
if __name__ == "__main__":
    pass
    ex1()
    
