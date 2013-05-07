from numpy import complex , flipud , fliplr , set_printoptions , ones , zeros , all , tile
from numpy.random import random
from numpy.fft import fftshift , fft2 , ifft2 , ifftshift
from scipy.signal import fftconvolve , convolve2d
set_printoptions(precision=2)

import matplotlib
matplotlib.use(’Qt4Agg’)
from matplotlib import pyplot as plot


