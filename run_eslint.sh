#!/bin/bash

read -p "Enter the directory path to scan (default: current directory): " SCAN_DIR
SCAN_DIR=${SCAN_DIR:-.}

if [ ! -d "$SCAN_DIR" ]; then
    echo "Error: Directory '$SCAN_DIR' does not exist."
    exit 1
fi

if ! command -v eslint &> /dev/null; then
    echo "ESLint is not installed. Installing ESLint..."
    npm install -g eslint
fi

if ! npm list -g eslint-plugin-security &> /dev/null; then
    echo "Installing eslint-plugin-security..."
    npm install -g eslint-plugin-security
fi

RESULTS_DIR="$SCAN_DIR/scan_results"
mkdir -p "$RESULTS_DIR"

ESLINT_CONFIG="$RESULTS_DIR/.eslintrc.cjs"

cat <<EOF > "$ESLINT_CONFIG"
module.exports = {
    plugins: ["security"],
    extends: ["plugin:security/recommended"],
    rules: {
        "security/detect-eval-with-expression": "error",
        "security/detect-child-process": "error",
        "security/detect-unsafe-regex": "error",
        "security/detect-pseudoRandomBytes": "error",
        "security/detect-possible-timing-attacks": "error",
        "security/detect-object-injection": "error",
        "security/detect-non-literal-require": "error",
                "security/detect-non-literal-regexp": "error",
        "security/detect-non-literal-fs-filename": "error",
        "security/detect-no-csrf-before-method-override": "error",
        "security/detect-new-buffer": "error",
        "security/detect-disable-mustache-escape": "error",
        "security/detect-buffer-noassert": "error",
        "security/detect-bidi-characters": "error"
    }
};
EOF

echo "Running ESLint security scan..."
eslint "$SCAN_DIR" --ext .js,.ts,.mjs --config "$ESLINT_CONFIG" --format json > "$RESULTS_DIR/eslint_scan.json"

echo "Scan complete! Results saved in: $RESULTS_DIR/eslint_scan.json"
