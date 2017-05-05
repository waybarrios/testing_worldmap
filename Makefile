#!/bin/sh
PNG_DIR=pngs
PNG_CROP=pngs_cropped
URL_DIR=urls
ID_DIR=ids
RESULT_DIR=results

SITEURL='http://54.186.220.207:8000/layers/geonode:'

IDS= $(wildcard $(ID_DIR)/*.id)
URLS= $(wildcard $(URL_DIR)/*.url)
PNGS=$(wildcard $(PNG_DIR)/*.png)
CROP=$(wildcard $(PNG_CROP)/*.png)

TARGET_URL=$(patsubst $(ID_DIR)/%.id, $(URL_DIR)/%.url, $(IDS))
TARGET_PNG=$(patsubst $(URL_DIR)/%.url, $(PNG_DIR)/%.png, $(URLS))
TARGET_CROP=$(patsubst $(PNG_DIR)/%.png, $(PNG_CROP)/%.png, $(PNGS))
TARGET_CHECK=$(patsubst $(PNG_CROP)/%.png, $(RESULT_DIR)/%.txt, $(CROP))
BACKGROUND=Gray
CHROME=/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary
SIZE=800,600
CROPSIZE=1230x750+180+400

folders:
		mkdir -p $(ID_DIR)
		mkdir -p $(URL_DIR)
		mkdir -p $(PNG_DIR)
		mkdir -p $(PNG_CROP)
		mkdir -p $(RESULT_DIR)

id: names.txt
		cat names.txt | xargs -I {} touch $(ID_DIR)/{}.id

all: 	
		folders
		id
		urls
		png
		crop


urls:	$(TARGET_URL)

png:	$(TARGET_PNG)
	
crop:	$(TARGET_CROP)

check:  $(TARGET_CHECK)

./$(URL_DIR)/%.url: ./$(ID_DIR)/%.id 
	echo '$(SITEURL)$(patsubst $(ID_DIR)/%,%,$(basename $<))' >> $@
	
./$(PNG_DIR)/%.png: ./$(URL_DIR)/%.url
	$(CHROME) --headless --screenshot --window-size=$(SIZE)  `cat '$<'`
	mv screenshot.png $@

./$(PNG_CROP)/%.png: ./$(PNG_DIR)/%.png
	convert '$<' -crop $(CROPSIZE) $@

./$(RESULT_DIR)/%.txt: ./$(PNG_CROP)/%.png
	 if [ "$(BACKGROUND)" == "$(shell identify -format "%[colorspace]\n" $<)" ]; then \
	 	echo 'FALSE' >> $@; \
	 else \
	 	echo 'TRUE' >> $@; \
	 fi
clean:
	find ./$(ID_DIR) -name "*.id" -print0 | xargs -0 rm
	find ./$(URL_DIR) -name "*.url" -print0 | xargs -0 rm
	find ./$(PNG_DIR) -name "*.png" -print0 | xargs -0 rm


	

