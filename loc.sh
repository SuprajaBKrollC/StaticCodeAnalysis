#!/bin/bash

# Calculate the lines of code of JS files in any specific directory

read -p "Enter the directory path to scan (default: current directory): " DIR
DIR=${DIR:-.}

if [ ! -d "$DIR" ]; then
    echo "Error: Directory does not exist!"
    exit 1
fi

TOTAL_LINES=$(find "$DIR" -type f -name "*.js" -exec cat {} + | wc -l) # This line can be customized based on any file extension
echo "Total number of lines in JavaScript (.js) files: $TOTAL_LINES"
