#!/bin/sh
PNG_DIR=pngs
URL_DIR=urls
ID_DIR=ids_new
SITEURL='http://54.186.220.207:8000/layers/geonode:'
IDS= $(wildcard ids/*.id)
TARGET=$(patsubst $(ID_DIR)/%.id, $(URL_DIR)/%.url, $(IDS))
FILE=/Users/waybarrios/harvard_test/layer_names.txt
TXT= `cat $(FILE)`

id:
		echo $(TXT)

all: 	$(TARGET)

urls:	$(TARGET)

./$(URL_DIR)/%.url: ./$(ID_DIR)/%.id 
	echo '$(SITEURL)$(patsubst $(ID_DIR)/%,%,$(basename $<))' >> $@
	
%.png: %.url
	touch $@

clean:
	@-rm *.url 

chrome:
	$(chrome-canary) --help

