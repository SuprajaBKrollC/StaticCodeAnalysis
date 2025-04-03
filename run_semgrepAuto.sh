#!/bin/bash

# Running Semgrep auto on directories
# This currently runs on all files regardless of file type 
# To run Semgrep Static Code Analysis do `$ semgrep login` and use your Semgrep credentials
# If not logged in, Semgrep auto will perform only basic test cases applicable

read -p "Enter the directory path to scan (default: current directory): " DIR
DIR=${DIR:-.}

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

if ! command -v semgrep &> /dev/null; then
    echo "Semgrep is not installed. Installing Semgrep..."
    pip install semgrep
fi

RESULTS_DIR="$DIR/scan_results"
mkdir -p "$RESULTS_DIR"
OUTPUT_FILE="$RESULTS_DIR/semgrep_results.json"

echo "Running Semgrep scan in $DIR..."
semgrep --config auto --json --output="$OUTPUT_FILE" "$DIR"

echo "Scan complete! Results saved in: $OUTPUT_FILE"
