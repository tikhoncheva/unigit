#/usr/bin/python

from numpy import set_printoptions , zeros , finfo, \
    exp, pi, isreal, real_if_close, fliplr, flipud
from numpy.random import rand
from numpy.fft import fftshift , fft2 , ifft2 , ifftshift
from scipy.signal import fftconvolve , convolve2d
set_printoptions(precision=2, linewidth=180)

import matplotlib
matplotlib.use('Qt4Agg')
from matplotlib import pyplot as plot

from pprint import pprint as pp


def getmat(width_low, width_med, n, content='low'):
    assert n%2 == 1, "n must be an odd number"
    assert width_low>=0, "width must be nonnegative" 
    assert width_med>=0, "width must be nonnegative" 
    
    mid = n/2
    
    # inner rectangle mask
    low = zeros((n,n))
    low[mid-width_low:mid+width_low+1,mid-width_low:mid+width_low+1] = 1
    
    # middle frame mask
    med = zeros((n,n))
    med[mid-width_low-width_med:mid+width_low+width_med+1,mid-width_low-width_med:mid+width_low+width_med+1] = 1
    med = med * (1-low)
    
    # random complex numbers of size nxn with amplitude 1
    rnd = exp(2*pi*1j*rand(n,n))
    
    if content=="low":
        mat = low*rnd
    else:
        mat = med*rnd

    # make ifft real
    mat = (mat + fliplr(flipud(mat)).conjugate())/2
    
    mat = ifftshift(mat)
    
    # check if we did it right
    should_be_real = real_if_close(ifft2(mat))
    assert isreal(should_be_real).all(), "The inverse FFT was not real."
    
    return mat 



if __name__ == "__main__":
    
    
    a = getmat(2,2,51,content='low')
    b = getmat(2,2,51,content='med')
    
    A = real_if_close(ifft2(a))
    B = real_if_close(ifft2(b))

    plot.figure()
    plot.subplot(1,2,1)
    plot.imshow(A, interpolation='nearest')
    plot.gray()
    
    plot.subplot(1,2,2)
    plot.imshow(B, interpolation='nearest')
    
    plot.show()
    
    C = convolve2d(A,B,boundary='wrap')
    
    if (abs(C) < finfo(float).eps).all():
        print("The images convolved to zero.")
    else:
        print("Convolution did not return zero.")
    