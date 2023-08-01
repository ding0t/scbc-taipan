#!/usr/bin/env bash
#
# ABOUT
# These functions find files
# 
# PROVIDES
#
# find_media_files_by_extension
# find_media_files_by_type
# find_delete_media_files_by_extension


#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
#	$1 optional extension like 'mp3'
# 	$2 optional path like '/home'
# Outputs:
#   Nil
#######################################
function find_media_files_by_extension(){
	A_MEDIA_FILES=(mp3 mov mp4 avi mpg mpeg flac m4a flv ogg mov mkv)
	A_IMAGE_FILES=(gif png jpg jpeg)
	search="*."
	dir="/home/"
	if $1; then
		find ${$2} -iname "${search}${1}" -type f
	else
		for i in "${A_MEDIA_FILES[@]}"; do
        	find ${dir} -iname "${search}${i}" -type f
		done
	fi
	#find . -name '*.mp3' -type f 
	
}

#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# 	$1 path
# Outputs:
#   Nil
#######################################
function find_media_files_by_type(){
	find "${1}" -type f -exec file -N -i -- {} + | grep video
	find "${1}" -type f -exec file -N -i -- {} + | grep audio
	
}

#######################################
# deletes media of type
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function find_delete_media_files_by_extension(){
	find ${$2} -iname "${search}${1}" -type f -delete
	
}