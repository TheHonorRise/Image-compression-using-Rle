# Image-compression-using-Rle
Elaboration d’une nouvelle technique de compression .IRM
## readIRM
a function similar to matlab's imread that takes the filename ("*.irm") as argument and return the image matrix, and the colors map
## writeIRM
a function similar to matlab's imwrite, it compresse the image, and make a ".irm" binary file
## isIRM
checks the signature of the irm file (should be 'IR')
## register 
a script to register the new image format '.IRM' as a recognizable format in matlab. (to use imread ans imwrite for .irm).
# User interface with matlab AppDesigner to test the proposed compression
