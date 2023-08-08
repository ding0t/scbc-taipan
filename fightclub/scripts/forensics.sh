#!/usr/bin/env bash
#
# ABOUT
# These functions find files
# 
# PROVIDES
#
# find_media_files_by_extension
# find_media_files_by_type
# delete_media_by_extension


#######################################
# what
# Globals:
#   nil
# Arguments:
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
# 	$1 path to search for files
# Outputs:
#   Nil
#######################################
function find_media_files_by_type(){
	local default_dir="/home/"
	find "${1:-${default_dir}}" -type f -exec file -N -i -- {} + | grep video
	find "${1:-${default_dir}}" -type f -exec file -N -i -- {} + | grep audio
	
}

#######################################
# deletes media of type
# Globals:
#   nil
# Arguments:
#	$1 extension list like 'mp3 ogg'
# 	$2 path like '/home'
# Outputs:
#   Nil
#######################################

function delete_media_by_extension(){
	search="*."
	find ${$2} -iname "${search}${1}" -type f -delete | tee -a "${logpath}"
}
