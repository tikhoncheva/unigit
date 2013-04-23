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


imfiles = ['f16.tiff', 'mandrill.tiff', 'lena.tiff', 'wildflower.png']

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
    
    
def show3Dscatter(*args, **kwargs):
    ax = plot.subplot(111, projection='3d')
    ax.set_title(kwargs.pop('title', 'No Title'))
    ax.set_xlabel(kwargs.pop('xlabel', 'X'))
    ax.set_ylabel(kwargs.pop('ylabel', 'Y'))
    ax.set_zlabel(kwargs.pop('zlabel', 'Z'))
    ax.scatter(*args, **kwargs)


if __name__ == "__main__":
    
    sample = 16
    
    for name in imfiles:
        
        #### scatter plot ####
        plot.figure()
        
        # read the image from file, subsample and scale to [0.0,1.0]
        img = subsample(readImage(name),4)/256
        
        # get single channels, shape isn't interesting
        r = img[:,:,0]
        g = img[:,:,1]
        b = img[:,:,2]
        
        # convert RGB to HSV
        h, s, v = vrgb2hsv(r,g,b)
        
        # create rgba tuples for plotting, 1 == opaque
        c = [(x,y,z,1) for x,y,z in zip(r.flat,g.flat,b.flat)]
        
        hflat = h.reshape(h.size)
        sflat = s.reshape(s.size)
        vflat = v.reshape(v.size)

        #show3Dscatter(r,g,b,c=c)
        
        # cylindrical coordinates
        # hue is angle, saturation is radius, value is length
        hflat = 2*np.pi*hflat
        hprime = np.cos(hflat)*sflat
        sprime = np.sin(hflat)*sflat
        vprime = v.flat
        
        show3Dscatter(hprime, sprime, vprime, c=c, edgecolor='None', xlabel='Hue/Saturation', ylabel='Hue/Saturation', zlabel='Value', title=name)
        
        
        #### single image plots ####
        
        imgs = [r,g,b,s,v] 
        titles = ['red', 'green', 'blue', 'saturation', 'value', 'hue']
        plot.figure()
        for i in range(len(imgs)):
            plot.subplot(2,3,i+1)
            showimg(imgs[i])
            plot.gray()
            
        plot.subplot(2,3,6)
        im = np.ndarray((r.shape[0], r.shape[1], 3))
        im[:,:,0],im[:,:,1],im[:,:,2] = vhsv2rgb(h, np.ones(h.shape), np.ones(h.shape))
        
        showimg(im)
        
        
      
    plot.show()
        