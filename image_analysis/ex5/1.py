#!/usr/bin/python

import vigra
import numpy as np

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot

from pprint import pprint as pp

def readvid():
    name = "cctv_video.h5"
    vol = vigra.readHDF5(name, 'data')
    return vigra.VigraArray(vol,axistags=vigra.defaultAxistags('xyt'))
    
    
def meanimage(im):
    t_index = -1
    for k in range(len(im.axistags)):
        if im.axistags[k].isTemporal():
            t_index = k
    
    assert not t_index < 0, "No time axis present."
    
    m = im.mean(axis=t_index)
    
    return m
    
def medianimage(im):
    return meanimage(im)
    
    
def test():
    vol = readvid()
    print(vol.shape,vol.axistags)
    plot.imshow(vol[:,:,0])
    plot.gray()
    plot.show()
    
def ex1():
    vol = readvid()
    meanim = meanimage(vol)
    medim = medianimage(vol)
    
    plot.subplot(1,2,1)
    plot.imshow(meanim.swapaxes(0,1))
    plot.gray()
    
    plot.subplot(1,2,2)
    plot.imshow(medim.swapaxes(0,1))
    plot.gray()
    
    plot.show()
if __name__ == "__main__":
    pass
    ex1()
    
