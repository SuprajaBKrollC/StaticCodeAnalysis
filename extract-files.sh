#!/bin/bash

read -p "Enter the directory path to scan (default: current directory): " DIR
DIR=${DIR:-.}

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

find "$DIR" -type f -name "*.js.gz" | while read -r file; do
    output_file="${file%.gz}"
    gunzip -c "$file" > "$output_file"
    echo "Extracted: $file → $output_file"
done

echo "Extraction complete!"
