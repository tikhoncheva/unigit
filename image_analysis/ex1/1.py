#!/usr/bin/python2

# numerics
import numpy as np

# imaging
from vigra.impex import readImage, writeImage
from vigra import RGBImage

import matplotlib 
matplotlib.use("Qt4Agg")
from mpl_toolkits.mplot3d import Axes3D 
from matplotlib import pyplot as plot
from colorsys import rgb_to_hsv, hsv_to_rgb


imfiles = ['f16.tiff', 'mandrill.tiff', 'lena.tiff', 'wildflower.png']

vrgb2hsv = np.vectorize(rgb_to_hsv)


def subsample(img, n):
    return img[0::n, 0::n, :]

def showimg(img):
    # use RGB type
    img = img.astype('uint8')
    
    # rescale
    img = img*256
    
    # correct axes
    img = img.swapaxes(0,1)
    
    
    plot.figure()
    plot.imshow(img)
    plot.show()
    
def show3Dscatter(*args, **kwargs):
    fig = plot.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.set_title(kwargs.pop('title', 'No Title'))
    ax.set_xlabel(kwargs.pop('xlabel', 'X'))
    ax.set_ylabel(kwargs.pop('ylabel', 'Y'))
    ax.set_zlabel(kwargs.pop('zlabel', 'Z'))
    ax.scatter(*args, **kwargs)
    plot.show()
    pass

if __name__ == "__main__":
    
    sample = 16
    
    for name in imfiles:
        
        # read the image from file, subsample and scale to [0.0,1.0]
        img = subsample(readImage(name),16)/256
        
        # get single channels, shape isn't interesting
        r = img[:,:,0].flat
        g = img[:,:,1].flat
        b = img[:,:,2].flat
        
        # convert RGB to HSV
        h, s, v = vrgb2hsv(r,g,b)
        
        # create rgba tuples for plotting, 1 == opaque
        c = [(x,y,z,1) for x,y,z in zip(r,g,b)]

        #show3Dscatter(r,g,b,c=c)
        
        # cylindrical coordinates
        # hue is angle, saturation is radius, value is length
        h = 2*np.pi*h
        hprime = np.cos(h)*s
        sprime = np.sin(h)*s
        vprime = v
        
        show3Dscatter(hprime, sprime, vprime,c=c, edgecolor='None', xlabel='Hue/Saturation', ylabel='Hue/Saturation', zlabel='Value', title=name)
        
        #break
        