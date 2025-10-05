#!/bin/bash

REPO_URL="https://github.com/ChrisTitusTech/nord-background"
TARGET_DIR="$HOME/Github/wallpaper"

git clone "$REPO_URL" "$TARGET_DIR" && echo "Repository cloned into '$TARGET_DIR' directory."
