#!/usr/bin/env bash
#
# ABOUT
# These functions find files
# 
# PROVIDES
#
#


#######################################
# what
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function find_media_files(){
	A_MEDIA_FILES=(mp3 mov mp4 avi mpg mpeg flac m4a flv ogg mov mkv)
	A_IMAGE_FILES=(gif png jpg jpeg)
	search="*."
	dir="/home/"
	find . -name '*.mp3' -type f 
	    for i in "${A_MEDIA_FILES[@]}"; do
        find ${dir} -iname '"${search}${i}"' -type f
    done
	write_log_entry "${logpath}" "${0}"
}