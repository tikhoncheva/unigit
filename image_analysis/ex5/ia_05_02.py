#!/usr/bin/python
# coding: utf-8
# 
# Author: Markus Doering
# File: ia_05_02.py
#

import vigra
import numpy as np

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot


class PatchMaker():
    W = 11
    H = 3
    l = 20
    s = 15
    
    
    def computeCostVolume(self, im1, im2):
        '''
        returns a cost volume 
        
        im1, im2 are images with axes order 'rc'
        '''
        
        cost_volume = np.ones((im1.shape[0], im1.shape[1], 2*self.l+1))*(-np.inf)
        
        for r in range(im1.shape[0]):
            print('Calculating in row {}'.format(r))
            for c in range(im1.shape[1]):
                p = self.patch(im1, r, c)
                if p is None:
                    continue
                
                for l in range(-self.l, self.l+1):
                    q = self.patch(im2, r, c-self.s+l)
                    if q is not None:
                        cost_volume[r,c,l+self.l] = nxcorr(p,q)
                    else:
                        cost_volume[r,c,:] = -np.inf
                        break
                
        return cost_volume
    
    def patch(self, im, row, col):
        '''
        im: image in 'rc' format
        '''
        
        rt = row - self.H//2
        rb = rt + self.H
        cl = col - self.W//2
        cr = cl + self.W
        
        if rt < 0 or cl < 0 or cr > im.shape[1] or rb > im.shape[0]:
            return None
        else:
            return im[rt:rb,cl:cr]
        
        

def nxcorr(p1,p2):
    '''
    normalized cross-correlation
    see http://en.wikipedia.org/wiki/Cross-correlation#Normalized_cross-correlation
    '''
    f = p1.reshape((-1,))
    t = p2.reshape((-1,))
    
    assert len(t) == len(f), "The patches must have the same number of elements ({} vs. {})".format(len(t),len(f))
    
    F = f-f.mean()
    T = t-t.mean()
    
    return np.dot(F/np.linalg.norm(F), T/np.linalg.norm(T))

def normalize(im):
    im = im-im.min()
    im = im/float(im.max())
    return im

def ex2():
    import matplotlib.image as mpimg
    import os.path
    L = mpimg.imread('scene1_row3_col1.png')
    R = mpimg.imread('scene1_row3_col3.png')
    GT = mpimg.imread('truedisp_row3_col3.png')
    
    P = PatchMaker()
    
    fn = 'cost_volume.h5'
    
    if not os.path.exists(fn):
        cost = P.computeCostVolume(L,R)
        vigra.writeHDF5(cost, fn, 'data')
    else:
        cost = vigra.readHDF5(fn, 'data')
        cost = cost.view(np.ndarray)
        
    scost = vigra.filters.gaussianSmoothing(vigra.taggedView(cost.astype(np.float32), axistags=vigra.defaultAxistags('yxc')),3.5)
    SD = normalize(np.argmax(np.flipud(scost.swapaxes(0,2)).swapaxes(0,2), axis=2))
    D = normalize(np.argmax(np.flipud(cost.swapaxes(0,2)).swapaxes(0,2), axis=2))
    
    
    

    plot.subplot(2,2,1)
    p = plot.imshow(L)
    plot.title('Left Image')
    plot.subplot(2,2,2)
    plot.imshow(R)
    plot.title('Right Image')
    plot.subplot(2,2,3)
    p = plot.imshow(D)
    p.set_cmap('hot')
    plot.title('Disparity Map')
    plot.subplot(2,2,4)
    p = plot.imshow(SD)
    p.set_cmap('hot')
    plot.title('Smoothened Disparity Map')
    
    plot.show()





if __name__ == "__main__":
    pass
    #testnxcorr()
    #testpatches()
    ex2()
    
    
    
    