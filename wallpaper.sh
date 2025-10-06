#!/bin/bash

REPO_URL="https://github.com/ChrisTitusTech/nord-background"
TARGET_DIR="$HOME/Github/wallpaper"

# Clone the repo
git clone "$REPO_URL" "$TARGET_DIR" && echo "Repository cloned into '$TARGET_DIR' directory."

# Remove the .git folder
rm -rf "$TARGET_DIR/.git"

# Rename all PNG images sequentially
cd "$TARGET_DIR" || exit 1

i=1
for file in *.png *.jpg *.jpeg; do
    # Skip if no files matched
    [ -e "$file" ] || continue

    # Get file extension
    ext="${file##*.}"

    # Rename file to i.ext (e.g., 1.png, 2.jpg, etc.)
    mv -- "$file" "${i}.${ext}"
    ((i++))
done

echo "Renamed all images in '$TARGET_DIR' to sequential filenames."
