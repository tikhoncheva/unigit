import numpy

def verticalPathsCosts(costMap):
    """ You are given a 2D costMap with shape costMap.shape
        In the picture below, the cost map's pixels are shown
        with 'x'; it has shape 5x4.

           s
        / | | \
        x x x x
        x x x x
        x x x x
        x x x x
        x x x x
        \ | | /
           t

        As output, we want to have -- for each pixel --
        the cost of the cheapest allowed path from the source 's'
        to the sink 't'. 
        Allowed paths are directed paths starting from the source,
        where each extension of an existing path can only go to the
        pixel below, or to the pixels (below, left) or (below,right).

        This is the same setup as in the lecture.

        As transition cost from pixel (i,j) to pixel (k,l), we use
        costMap[k,l].

        Note that the edges connecting s and the image as well as the
        edges connecting the image and t have 0 weight.

        New functions to learn which could be useful:
        numpy.ones, numpy.zeros
    """

    pathCosts = None #initialize array here
    # IMPLEMENT ME HERE
    assert pathCosts.shape == costMap.shape
    return pathCosts

def verticalPath_backtracking(cumulativeCosts):
    """ Given the cost for allowed paths from 's' to each pixel
        in the array cumulativeCosts, find the
        minimum costs path from 't' to 's'.

        To do this, use backtracking as described in the lecture.

        Return an array with data type dtype=numpy.uint8
        where each pixel that is traversed by the minimum cost path
        is set to 1, while all other pixels are set to zero.

        New functions to learn which could be useful:
        numpy.argmin, numpy.argmax
    """

    pathImg = None #initialize array here
    # IMPLEMENT ME HERE
    assert pathImg.shape == cumulativeCosts.shape
    assert pathImg.dtype == numpy.uint8 
    return pathImg
def mkCostMap(img1, img2):
    """Given two images, compute the pixel-wise L2 norm of the
       difference image.

       Note: this is a one-liner using numpy!

       New functions to learn which could be useful:
       http://docs.scipy.org/doc/numpy/reference/routines.math.html
    """
       
    assert img1.shape == img2.shape
    assert img1.dtype == numpy.float32
    assert img2.dtype == numpy.float32
    assert img1.ndim == 3 and img2.ndim == 3

    pass #IMPLEMENT ME (in one line, please)
