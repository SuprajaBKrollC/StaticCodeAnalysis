#!/bin/bash

# Prompt user for the directory to scan
read -p "Enter the directory path to scan (default: current directory): " DIR
DIR=${DIR:-.}  # Default to current directory if no input

# Ensure the directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

# Ensure Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js."
    exit 1
fi

# Ensure ESLint is installed
if ! command -v eslint &> /dev/null; then
    echo "ESLint is not installed. Installing ESLint..."
    npm install -g eslint
fi

# Ensure nodejsscan is installed
if ! command -v nodejsscan &> /dev/null; then
    echo "nodejsscan is not installed. Installing nodejsscan..."
    pip install nodejsscan  # Requires Python & Pip
fi

# Create scan_results directory

SCAN_RESULTS_DIR="$DIR/scan_results"
mkdir -p "$SCAN_RESULTS_DIR"

echo "Running npm audit for known vulnerabilities..."
npm audit --audit-level=high --json > "$SCAN_RESULTS_DIR/npm_audit_report.json"

echo "Running nodejsscan..."
nodejsscan -d "$DIR" -o "$SCAN_RESULTS_DIR/nodejsscan_report.json"

echo "Scan complete! Reports saved in $SCAN_RESULTS_DIR"
