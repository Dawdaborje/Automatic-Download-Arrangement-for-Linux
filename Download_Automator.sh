#!/bin/bash

# Specify the source directory where your files are located
SOURCE_DIR="/home/borje/Downloads"

# Create an associative array to map extensions to folder names
declare -A EXTENSION_MAP
EXTENSION_MAP["txt"]="TextFiles"

# Images
EXTENSION_MAP["jpg"]="ImageFiles"
EXTENSION_MAP["jpeg"]="ImageFiles"
EXTENSION_MAP["webp"]="ImageFiles"
EXTENSION_MAP["png"]="ImageFiles"
EXTENSION_MAP["svg"]="ImageFiles"
EXTENSION_MAP["avif"]="ImageFiles"

# Document files
EXTENSION_MAP["zip"]="ZipFiles"
EXTENSION_MAP["rar"]="ZipFiles"
EXTENSION_MAP["pdf"]="PDFFiles"

# Video Files
EXTENSION_MAP["mp4"]="VideoFiles"
EXTENSION_MAP["mkv"]="VideoFiles"


# Office Docs
EXTENSION_MAP["pptx"]="OfficeFiles/publisher"

# Windows Files
EXTENSION_MAP["exe"]="Windows/applications"


# Add more extensions and corresponding folder names as needed

# Function to organize a file based on its extension
organize_file() {
    file="$1"
    extension="${file##*.}"

    if [ -n "${EXTENSION_MAP[$extension]}" ]; then
        # Create the destination folder if it doesn't exist
        mkdir -p "$SOURCE_DIR/${EXTENSION_MAP[$extension]}"

        # Move the file to the appropriate folder
        mv "$file" "$SOURCE_DIR/${EXTENSION_MAP[$extension]}/"

        echo "Moved $file to ${EXTENSION_MAP[$extension]} folder."
    else
        echo "No specific folder defined for $file with extension $extension."
    fi
}

# Organize existing files in the Downloads directory
for existing_file in "$SOURCE_DIR"/*; do
    if [ -f "$existing_file" ]; then
        organize_file "$existing_file"
    fi
done

# Use inotifywait to monitor the download directory for new files
inotifywait -m -e create --format '%w%f' "$SOURCE_DIR" | while read -r new_file; do
    echo "New file detected: $new_file"
    organize_file "$new_file"
done
