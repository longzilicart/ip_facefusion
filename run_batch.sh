

#!/bin/bash

# Check the args num
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 [-s parameter] [-t parameter] [-o parameter]"
    exit 1
fi

# args, source, target, output folder
s_param=$1
t_param=$2
o_param=$3

# supported file formats
image_formats=("jpg" "jpeg" "png" "gif" "JPG" "JPEG" "PNG" "GIF")
video_formats=("mp4" "MP4")

# Process single file
process_file() {
    file=$1
    extension="${file##*.}"
    extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    # use the provided py script 
    # TODO we can provide more kewargse here 
    python run.py --headless -o "$o_param" -s "$s_param" -t "$file" || return
}

# Check if the -t parameter is a file or a directory
if [ -d "$t_param" ]; then
    # If a directory, iterate all image and video inside
    for file in "$t_param"/*; do
        if [ -f "$file" ]; then
            extension="${file##*.}"
            extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
            if [[ " ${image_formats[*]} ${video_formats[*]} " =~ " $extension_lower " ]]; then
                process_file "$file"
            fi
        fi
    done
elif [ -f "$t_param" ]; then
    # single file, check if it's a supported image or video format
    extension="${t_param##*.}"    extension="${t_param##*.}"
    extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
    if [[ " ${image_formats[*]} ${video_formats[*]} " =~ " $extension_lower " ]]; then
        process_file "$t_param"
    else
        echo "The provided -t parameter is not a supported image or video format: $t_param"
        exit 1
    fi
else
    echo "The provided -t parameter is not a valid file or directory path: $t_param"
    exit 1
fi
