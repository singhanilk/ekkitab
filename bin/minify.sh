#!/bin/bash 

# minify.sh
# Usage minify.sh [directory]
# This script will recursively traverse the directory and minify all the css and js files types.
# The script appends _min to the base file name. eg layout.css will be layout_min.css 
# All non-css and js file types are ignored.
# Files name with _min as part of base file name (assumed is already minifed) are ignored 
# YUI Compressor is used for the minification.
# SYLVESTER THOMAS 05-May-2010.

DIR="."		#default = current directory

function get_files()
{
    if !(test -d "$1") then #direcotry not found 
	echo $1; 
	return;
    fi

    cd "$1"
    echo; echo "Working on: " `pwd`:; #display directory name

    for file  in *
    do
	if (test -d "$file") #if dictionary
	then
		get_files "$file" #recursively get files
                cd ..
	else
#					protect from minifying the minified files!! :-)
		res=`perl -e "if ( '$file' =~ /_ek_min\./) { print 'yes'}else{print 'no'}"`
		echo; echo Inspecting file: $file - Compress = : $res

		if [ "$res" == 'yes' ]	
		then
			echo NOT Processing: "$file"
		else 
			ftype=""
			if [ "${file##*.}" == "css" ] 
			then 
                		ftype="--type css"
			elif [ "${file##*.}" == "js" ]
			then
                		ftype="--type js"
			fi
		
			echo File Type is: "${file##*.}"
			if [ "${ftype}" != "" ]	
			then
				echo Processing file: "$file"
#				java -jar ../yuicompressor-2.4.2.jar "$ftype" "$file" -o  "${file%.*}"_ek_min."${file##*.}" 
				java -jar yuicompressor-2.4.2.jar "$file"  -o  "${file%.*}"_ek_min."${file##*.}" 
			fi
		fi
	fi
    done
}

if [ $# -eq 0 ] # run default directory
then
	get_files .
	exit 0
fi

for i in $*
do
    DIR="$1"
    get_files "$DIR"
    shift 1  #Get the next directory/file name
done

#-----------------------------
# End of File.
#-----------------------------


