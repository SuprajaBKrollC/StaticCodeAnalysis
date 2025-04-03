#!/bin/bash

read -p "Enter the directory path to scan (default: current directory): " SCAN_DIR
SCAN_DIR=${SCAN_DIR:-.}  # Default to current directory if no input

if [ ! -d "$SCAN_DIR" ]; then
    echo "Error: Directory '$SCAN_DIR' does not exist."
    exit 1
fi

read -p "Enter the path to the custom Semgrep rules folder: " RULES_DIR

if [ ! -d "$RULES_DIR" ]; then
    echo "Error: Custom rules directory '$RULES_DIR' does not exist."
    exit 1
fi

# Check if Semgrep is installed, install if missing
# if ! command -v semgrep &> /dev/null; then
#echo Semgrep is not installed. Installing Semgrep..."
    # pip install --user semgrep
# fi

RESULTS_DIR="$SCAN_DIR/scan_results"
mkdir -p "$RESULTS_DIR"

for RULE_FILE in "$RULES_DIR"/*.yml; do
    if [ -f "$RULE_FILE" ]; then
        RULE_NAME=$(basename "$RULE_FILE" .yaml)  # Extract rule name (without extension)
        OUTPUT_FILE="$RESULTS_DIR/semgrep_${RULE_NAME}.json"

        echo "Running Semgrep scan with rule: $RULE_NAME..."
        semgrep --config="$RULE_FILE" --json --output="$OUTPUT_FILE" "$SCAN_DIR"

        echo "Results for '$RULE_NAME' saved in: $OUTPUT_FILE"
    fi
done
