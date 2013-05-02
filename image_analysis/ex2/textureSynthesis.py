#!/usr/bin/python

import numpy
import vigra
import math
import sys
import os
import errno
import shutil

#
# import the functions you have implemented in
# textureSynthesis_helpers.py
#
from textureSynthesis_helpers import mkCostMap
from textureSynthesis_helpers import verticalPathsCosts
from textureSynthesis_helpers import verticalPath_backtracking

#=---------------------------------------------------------------------------=
#= patchDistances ============================================================
#=---------------------------------------------------------------------------=

def patchDistances(referencePatch, patches):
    """ We are given the output of 'mkPatches' in the patches variable.
        We want to compute the distance of 'referencePatch' to all the
        patches in patches.

        However, our referencePatch might be smaller than all other 
        patches. This is because we will use this function to compute
        the distances of reference patches corresponding to the overlap
        regions of patches.

        The origin of referencePatch and patches[:,:,patchIndex]
        are both (0,0).

        Return a 1D array of distances.

        New functions to learn which could be useful:
        numpy.tile
    """

    ov = patches[0:referencePatch.shape[0],0:referencePatch.shape[1],:,:]
    distances = ov - numpy.tile(referencePatch, (1, 1, 1, patches.shape[3]))
    distances = numpy.sqrt(numpy.sum(numpy.square(distances), axis=2))
    
    # have version 1.6 < 1.7 !
    if numpy.__version__ >= 1.7 and False:
        distances = numpy.sum(distances, axis=(0,1))
    else:
        distances = numpy.sum(distances, axis=0)
        distances = numpy.sum(distances, axis=0)
    
    return distances


#=---------------------------------------------------------------------------=
#= cheapestVerticalPath ======================================================
#=---------------------------------------------------------------------------=

def cheapestVerticalPath(c):
    """ Given a cost map 'c' as input,
        compute the image where the minimum cost allowed path
        is designated by '1', and all other pixels by '0'.

        This function is already implemented for you.
    """
    costs = verticalPathsCosts(c)
    y = verticalPath_backtracking(costs)
    return y

#=---------------------------------------------------------------------------=
#= cheapest*Cut ==============================================================
#=---------------------------------------------------------------------------=

def cheapestVerticalCut(c):
    """ Given the cost map, 
        generate a binary mask for the minimal cut.
        Everything to the left of the path (including the path)
        should be assigned 1, while everything right of the path
        should be assigned 0.
    """

    #>>>>
    y = cheapestVerticalPath(c)
    for row in range(y.shape[0]):
        y[row, 0:numpy.argmax(y[row,:])] = 1
    return y
    #<<<<
    #mask = None
    ## IMPLEMENT ME HERE
    #assert mask.shape == c.shape
    #return mask #return the binary mask for the cut

def cheapestHorizontalCut(c):
    return cheapestVerticalCut(c.T).T

#=---------------------------------------------------------------------------=
#= mkPatches =================================================================
#=---------------------------------------------------------------------------=

def mkPatches(img, patchSize):
    """ Given in img of shape img.shape, and a patch size patchSize,
        return an array of shape "patchSize x patchSize x #number of patches"
        containing all possible "patchSize x patchSize" patches in img.

        Let ret be the variable of the array to be returned.
        Then ret[:,:,idx] shall hold the idx'th patch of size patchSize x patchSize.

        Be careful to obey the array's boundaries!
    """

    assert img.ndim == 3, "image should have channel axis"

    nX = img.shape[0]-patchSize
    nY = img.shape[1]-patchSize
    nChannels = img.shape[2]
    patches = numpy.zeros( (patchSize,patchSize, nChannels, nX*nY), img.dtype )

    k = 0
    for i in range(nX):
        for j in range(nY):
            x, X = i, i+patchSize
            y, Y = j, j+patchSize
            patches[:,:,:,k] = img[x:X, y:Y,:]
            k += 1
    return patches


#=---------------------------------------------------------------------------=
#= chooseMatchingPatch =======================================================
#=---------------------------------------------------------------------------=

def chooseMatchingPatch(distances):
    """ Given a 1-D array of patch distances, choose among
        suitable candidates an index (which corresponds to a patch index)
        Return this index.
    """
    assert distances.ndim == 1
    assert distances.dtype == numpy.float32

    d = distances
    #make sure we do not use the current patch
    d[ d < numpy.finfo(d.dtype).eps ] = 99999
    m = numpy.min(d)
    thresh = 1.1*m
    theIdxs = numpy.where(d < thresh)[0] 
    print "  %d patch candidates" % len(theIdxs)
    theIdx = theIdxs[numpy.random.randint(0,len(theIdxs))]
    return theIdx

#=---------------------------------------------------------------------------=
#= debug helpers =============================================================
#=---------------------------------------------------------------------------=

def debug_writeCut(cut, ov1, ov2, costMap, filePrefix):
    import h5py
    vigra.impex.writeImage(ov1.astype(numpy.uint8), filePrefix+"_1.png")
    vigra.impex.writeImage(ov2.astype(numpy.uint8), filePrefix+"_2.png")
    vigra.impex.writeImage(costMap.astype(numpy.uint8), filePrefix+"_3.png")
    vigra.impex.writeImage(255*cut, filePrefix+"_4.png")
    f = h5py.File(filePrefix+".h5", 'w')
    f.create_dataset("cost_map", data=costMap)
    f.close()

def mkdir_p(path):
    if os.path.exists(path):
        return
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST:
            pass
        else: raise

#=---------------------------------------------------------------------------=
#= mkTexture =================================================================
#=---------------------------------------------------------------------------=

def mkTexture(textureSize, patches, overlap, debug=False, useCut=True):
    """ This is the main routine which draws all previous functions
        together, in order to implement the texture synthesis algorithm
        as described in
            "Image Quilting for Texture Synthesis and Transfer",
            E. Efros, W. Freeman, SIGGRAPH 2001.
        
        textureSize: shape of the output texture (2-element tuple)
        patches:     patches extracted from the input texture using
                     mkPatches
        overlap:     overlap of adjacent patches in pixels
        debug:       If true, writes 
    """
    assert len(textureSize) == 2
    assert patches.shape[0] == patches.shape[1]
    patchSize = patches.shape[0]
    tileSize  = patchSize - overlap 
    nChannels = patches.shape[2]
    texture = numpy.zeros((textureSize[0], textureSize[1], nChannels), dtype=numpy.float32) 

    nPatches = patches.shape[2]

    assert numpy.all(textureSize > patchSize)

    if debug:
        try:
           shutil.rmtree("debug_stitching")
        except:
            pass
        try:
            shutil.rmtree("debug_cuts")
        except:
            pass
        mkdir_p("debug_stitching")
        mkdir_p("debug_cuts")

    k = -1

    N = int(math.ceil(textureSize[0]/float(tileSize)))
    M = int(math.ceil(textureSize[1]/float(tileSize)))
    for i in range(N): #width
        for j in range(M): #height
            print "iter (%d,%d) %d/%d" % (i,j, M*i+j, N*M)
           
            k += 1
            if k == 0:
                #as first tile, use a random patch
                texture[0:patchSize, 0:patchSize,:] = patches[:,:,:,numpy.random.randint(0,nPatches)]
                continue

            blockLeft  = j>0
            blockAbove = i>0

            #slicing for left overlap
            sl_l =  (slice(i*tileSize, min(i*tileSize+patchSize, texture.shape[0])),
                     slice(j*tileSize, min(j*tileSize+overlap, texture.shape[1])),
                     slice(0,nChannels))
            #slicing for above overlap
            sl_a =  (slice(i*tileSize, min(i*tileSize+overlap, texture.shape[0])),
                     slice(j*tileSize, min(j*tileSize+patchSize, texture.shape[1])),
                     slice(0,nChannels))
            #slicing for the overlap of "left overlap" and "right overlap"
            sl_la    = (sl_a[0], sl_l[1], slice(0,nChannels))
            sl_la0   = tuple([slice(0,tmp.stop-tmp.start) for tmp in sl_la])
            #slicing to write a PATCH at position (i,j)
            patchSl  = (slice(i*tileSize, min(i*tileSize+patchSize, texture.shape[0])),
                        slice(j*tileSize, min(j*tileSize+patchSize, texture.shape[1])),
                        slice(0,nChannels))
            patchSl0 = tuple([slice(0,tmp.stop-tmp.start) for tmp in patchSl])


            if blockLeft:
                ov1 = texture[sl_l[0], sl_l[1], :, numpy.newaxis]
                dLeft = patchDistances(ov1, patches)
                d = dLeft

            if blockAbove:
                ov1 = texture[sl_a[0], sl_a[1], :, numpy.newaxis] 
                dAbove = patchDistances(ov1, patches)
                d = dAbove

            if blockLeft and blockAbove:
                d = dLeft+dAbove

                ov1 = texture[sl_la[0], sl_la[1], :, numpy.newaxis] 
                dBoth = patchDistances(ov1, patches)
                d -= dBoth

            #choose among possible good matches a patch
            chosenPatchIndex = chooseMatchingPatch(d)
            chosenPatch =  patches[patchSl0[0], patchSl0[1], :, chosenPatchIndex]

            if not useCut:
                texture[patchSl] = chosenPatch
            else:
                if blockLeft:
                    ov1 = texture[sl_l]
                    ov2 = chosenPatch[0:ov1.shape[0],0:ov1.shape[1]]
                    costMap = mkCostMap(ov1, ov2)
                    cut = cheapestVerticalCut(costMap)

                    optCutLeft = numpy.where(numpy.dstack([cut]*nChannels), ov1, ov2)
                    cutLeft = cut

                    if debug:
                        debug_writeCut(cut, ov1, ov2, costMap, "debug_cuts/cut%04d_l" % k)
                        tex = texture.copy()
                        tex[sl_l] *= numpy.dstack([cutLeft]*nChannels)
                        vigra.impex.writeImage(tex.astype(numpy.uint8), "debug_stitching/step%04d_1.png" % k)


                if blockAbove:
                    ov1 = texture[sl_a] 
                    ov2 = chosenPatch[0:ov1.shape[0],0:ov1.shape[1]]
                    costMap = mkCostMap(ov1, ov2)
                    cut = cheapestHorizontalCut(costMap)

                    optCutAbove = numpy.where(numpy.dstack([cut]*nChannels), ov1, ov2)
                    cutAbove = cut

                    if debug:
                        debug_writeCut(cut, ov1, ov2, costMap, "debug_cuts/cut%04d_a" % k)
                        tex = texture.copy()
                        tex[sl_a] *= numpy.dstack([cutAbove]*nChannels)
                        vigra.impex.writeImage(tex.astype(numpy.uint8), "debug_stitching/step%04d_2.png" % k)

                if blockAbove and blockLeft:
                    x1 = cutLeft[sl_la0[0:2]]
                    x2 = cutAbove[sl_la0[0:2]]
                    x  = numpy.logical_or(x1, x2)
                    cutLeft[sl_la0[0:2]] = x
                    cutAbove[sl_la0[0:2]] = x

                    ov1 = texture[sl_l]
                    ov2 = chosenPatch[0:ov1.shape[0],0:ov1.shape[1],:]
                    optCutLeft = numpy.where(numpy.dstack([cutLeft]*nChannels), ov1, ov2)

                    ov1 = texture[sl_a] 
                    ov2 = chosenPatch[0:ov1.shape[0],0:ov1.shape[1],:]
                    optCutAbove = numpy.where(numpy.dstack([cutAbove]*nChannels), ov1, ov2)

                    if debug:
                        tex = texture.copy()
                        tex[sl_l] *= numpy.dstack([cutLeft]*nChannels)
                        tex[sl_a] *= numpy.dstack([cutAbove]*nChannels)
                        vigra.impex.writeImage(tex.astype(numpy.uint8), "debug_stitching/step%04d_3.png" % k)

                #first, write chosen patch
                texture[patchSl] = chosenPatch
                #finally, write out the cut overlap regions
                if blockLeft:
                    texture[sl_l] = optCutLeft
                if blockAbove:
                    texture[sl_a] = optCutAbove

                if debug:
                    vigra.impex.writeImage(texture.astype(numpy.uint8), "debug_stitching/step%04d_5.png" % k)


    return texture

def test_paths():
    x = [[3,1,2,2],
         [3,2,1,2],
         [3,1,2,2],
         [3,1,2,2],
         [3,2,1,2],
         [3,2,1,2],
         [3,2,1,2],
         [3,2,5,1],
         [3,2,9,1]]
    x = numpy.asarray(x)
    print x
    print cheapestVerticalPath(x)
    print cheapestVerticalCut(x)

#=---------------------------------------------------------------------------=
#= if __name__ == "__main__" =================================================
#=---------------------------------------------------------------------------=

if __name__ == "__main__":
    #Enable here to test your code with small data
    #test_paths()
    #sys.exit()

    #Load an image.
    #We convert it to gray value before using it.
    fname = "matrix_s.jpg"
    img = vigra.impex.readImage(fname)

    #make sure we got an RGB or grayscale image
    assert img.ndim == 3 and (img.shape[2] == 3 or img.shape[2] == 1), img.shape

    #if you want this to run faster, work on a grayscale image
    #
    # img = numpy.average(img, axis=2)
    # img = 255.0*(img-img.min())/float(img.max()-img.min())
    # img = img[:,:,numpy.newaxis] #add a singleton channel axis,
    #                              #such that img has img.ndim == 3

    print "mkPatches"
    patches = mkPatches(img, 30)
    print "mkTexture"
    img = mkTexture((300, 150), patches, overlap=10, debug=True, useCut=True)
    outFname = os.path.splitext(fname)[0]+"_generated.png"
    print "saving generated texture as '%s'" % outFname
    vigra.impex.writeImage(img.astype(numpy.uint8), outFname)
    
