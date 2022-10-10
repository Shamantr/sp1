#!/bin/bash
# This script applies to convert image with size reshape
echo " Image convert script."
echo " Author: V.A. Nuzhin"
echo " Use this script for convert images to formats. Base framework is Imagemagick."
echo " "


# Save current script path
orig_way=$(pwd)

ext0=""
err=0
while [ "$ext0" != "n" ]; do
    # Exit loop
    read -p " Press any key to continue or press n to exit script [n|no|any key]: " ext0
    ext0=${ext0,,}

    if [[ $ext0 == "n" || $ext0 == "no" ]]; then
        break
    fi

    # Try to get file
    echo " Choose image to copy-convert by enter filename by way:"
    echo " FILE.ext           - local file"
    echo " DIR/.../FILE.ext   - local path to file"
    echo " ./DIR/.../FILE.ext - absolute path to file"
    ext1=1
    ext2=1
    FILE=""
    while [ $ext1 -gt 0 ]; do
	# Check curr dir
	if [ "$(pwd)" != "$orig_way" ]; then
	    cd "$orig_way" || exit
	fi

    	# get file name from terminal
    	read FILE
	if [ -f "$FILE" ]; then
	    # this works if way is local
            echo " $FILE exists. Continue."
            ext1=$(( ext1 - 1 ))
        else
	    cd ~ || exit # go to homedir
	    if [ -f "$FILE" ]; then
		# this works if way is absolute
	        echo " $FILE exists. Continue."
		ext1=$(( ext1 - 1))
	    else
		# failed to find file by way
           	read -p "$FILE does not exists. Press any key to try again [n|no|any key]? " ext0
		ext0=${ext0,,}

		# Return to beginning
		if [[ $ext0 == "n" || $ext0 == "no" ]]; then
		    ext2=0

		    break
		fi
	    fi
        fi
    done

    # Image wasn't chose
    if [ "$ext2" == "0" ]; then
	echo " Go to beginning"

        continue
    fi

    # Optional get output way
    read -p " Wanna set output way [y|yes|any key]? " ext0
    ext0=${ext0,,}

    output_dir="$orig_way"

    if [[ $ext0 == "y" || $ext0 == "yes" ]]; then
        echo " Choose output path by way: "
	echo " DIR0/.../DIRn - local path"
	echo " ~/DIR0/.../DIRn - abs path"
        ext1=1
        DIR=""
        while [ $ext1 -gt 0 ]; do
	    # Check curr dir
	    if [ "$(pwd)" != "$orig_way" ]; then
	        cd "$orig_way" || exit
	    fi

    	    # get dir name from terminal
    	    read DIR

	    if [ "$DIR" == "" ]; then
		echo " Default local path"

		break
	    fi

	    if [ -d "$DIR" ]; then
	        # this works if way is local
                echo " $DIR exists. Continue."
		output_dir="$DIR"
                ext1=$(( ext1 - 1 ))
            else
	        cd ~ || exit # go to homedir
	        if [ -d " $DIR" ]; then
		    # this works if way is absolute
	            echo " $DIR exists. Continue."
		    output_dir="$DIR"
		    ext1=$(( ext1 - 1))
	        else
		    # failed to find dir by way
           	    read -p " $DIR does not exists. Press any key to try again [n|no|any key]: " ext0
		    ext0=${ext0,,}

		    if [[ $ext0 == "n" || $ext0 == "no" ]]; then
			break
		    fi
	        fi
            fi
        done
    fi

    # Curr output way
    echo " Current output way: $output_dir"

    filename=$(basename -- "$FILE")
    # extension="${filename##*.}"
    filename="${filename%.*}"

    # Choose new format
    read -p " Enter file extension: " extension

    # Choose new height and width size (optional)
    read -p " Press any key if you don't want to choose new file size [y|yes|any key]: " ext0
    ext0=${ext0,,}

    if [[ $ext0 == "y" || $ext0 == "yes" ]]; then
        read -p " Enter file width and height: " width height

	# Try to convert file
        convert -quiet "$FILE" -resize "$width"x"$height"! "$filename"."$extension" 2> errors.txt
    else
	# Try to convert file
	convert -quiet "$FILE" "$filename"."$extension" 2> errors.txt
    fi
    err=$?

    if [ $err == 0 ]; then
	# if output isn't local
	if [ "$output_dir" != "$orig_way" ]; then
	    # Move converted file to output folder
	    mv "${filename}.${extension}" "$output_dir"
	fi
        echo " Conversion's successful. Try again?"
        echo ""
    else
        echo " Operation isn't successful due error. See errors.txt for details."
        echo ""
    fi
done

if [ $err == 0 ]; then
    echo " Script was terminated without errors."
else
    echo " Script was terminated with last error code $err"
fi
