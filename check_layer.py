import cv2
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import scipy as sp
import os


def check_background (folder,img_path):
	background_color=221 #color background
	img = cv2.imread(os.path.join(folder,img_path), cv2.COLOR_BGR2RGB)
	crop_img = img[400:1150, 180:1410]
	background=np.ones((crop_img.shape))*background_color
	foreground=crop_img - background
	if np.mean(foreground):
		return True
	return None 

folder='test'
images=[fi for fi in os.listdir(folder) if fi.endswith('.png')]
damaged_layers=[]

for img in images:
	print check_background(folder,img)
	if not (check_background(folder,img)):
		damaged_layers.append(os.path.splitext(img)[0])

thefile=open('damaged_layers.txt', 'w')
for item in damaged_layers:
  thefile.write("%s\n" % item)