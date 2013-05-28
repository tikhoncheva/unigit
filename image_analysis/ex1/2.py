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
from colorsys import rgb_to_hsv, hsv_to_rgb, rgb_to_yiq


imfiles = ['f16.tiff', 'lena.tiff', 'wildflower.png', 'mandrill.tiff', ]

vrgb2hsv = np.vectorize(rgb_to_hsv)
vhsv2rgb = np.vectorize(hsv_to_rgb)
vrgb2yiq = np.vectorize(rgb_to_yiq)


def subsample(img, n):
    return img[0::n, 0::n, :]

def showimg(img):
    # use RGB type
    img = img * 256
    img = img.astype('uint8')
    
    # correct axes
    img = img.swapaxes(0,1)

    plot.imshow(img)
    
    
def show3Dscatter(m,n,k,*args, **kwargs):
    ax = plot.subplot(m,n,k, projection='3d')
    ax.set_title(kwargs.pop('title', 'No Title'))
    ax.set_xlabel(kwargs.pop('xlabel', 'X'))
    ax.set_ylabel(kwargs.pop('ylabel', 'Y'))
    ax.set_zlabel(kwargs.pop('zlabel', 'Z'))
    ax.scatter(*args, **kwargs)


if __name__ == "__main__":
    
    
