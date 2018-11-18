<h2>Explaination:</h2>

The traditional implementation uses the texture of surrounding areas and fill the area but it does not usually produce good results, so we used a combination of Object Detection and surrounding textures to get the desired output.

The model was trained on Places2 Dataset: (http://places2.csail.mit.edu/) so it works best on Outdoor Natural Images and can be extended to other datasets as well very easily.

For every image we take input the file, We learn to inpaint missing regions with a deep convolutional network. Our network completes images of arbitrary resolutions by filling in missing regions of any shape. We use global and local context discriminators to train the completion network to provide both locally and globally consistent results.

----------------------------------------------------------------
<h2>Usage:</h2>


<h3>Step 1:</h3>
Download the model by running the download script:
	
	bash download_model.sh
<h3>Step 2:</h3>
INSTALLING DEPENDENCIES
	
	git clone https://github.com/torch/distro.git ~/torch --recursive
	cd ~/torch; bash install-deps;
	./install.sh
	luarocks install image
	Once installed we can run torch using th command

<h3>Step 3:</h3>
Now,Copy the redacted images into the input folder and run 
	
	python final.py	
	
Note: The image should be redacted (erased) with HEx values: #010203 and NOT any other color and should use Paint 3d in Windows and gnome-paint drawing editor in Linux

<h3>Step 4:</h3>
Output can be found in output Directory

----------------------------------------------------------------
<h2>Best Performance:</h2>

-This model was trained on the Places2 dataset and thus best performance is for natural outdoor images.

-While the model works on images of any size with holes, we trained it on images with the smallest edges in the [256, 384] pixel 	range and random holes in the [96, 128] pixel range. Our model will work best on images with holes of those sizes.

-Significantly large holes or extrapolation when the holes are at the border of images may fail to be filled in due to limited 		spatial support of the model.

This code provides an extension to the the research paper:

"Soheil Darabi, Eli Shechtman, Connelly Barnes, Dan B Goldman, and Pradeep Sen. 2012. Image Melding: Combining Inconsistent Images using Patch-based Synthesis. ACM Transactions on Graphics"
