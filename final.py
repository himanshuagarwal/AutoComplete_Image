from PIL import Image
import os
from shutil import copyfile

path_1 = "input/"
path_2 = "output/"
os.system("rm -rf output/")
os.system("mkdir output")
listing = os.listdir(path_1)
for file in listing:
	copyfile(path_1+file, path_2+file)	
	im = Image.open(path_2+file)
	im.convert('RGB')
	pix = im.load()
	# pix2 = im.load()
	# print im.size
	x, y = im.size
	img = Image.new(im.mode, im.size)
	pixelsNew = img.load()
	for i in range(0, x):
		for j in range(0, y):
		    if pix[i, j] == (1, 2, 3):
		        pixelsNew[i, j] = (255, 255, 255)
		    else:
		        pixelsNew[i, j] == (0, 0, 0)
	img.save('mask.png')
	im.close()
	os.system("th inpaint.lua --input "+path_2+file+" --mask mask.png")
	copyfile("out.png",path_2+"out_"+file)
	os.system("rm mask.png")
        os.system("rm out.png")
        os.system("rm input.png")
