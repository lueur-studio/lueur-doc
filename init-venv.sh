#!/bin/bash
# Initializes a virtual environment and installs dependencies

VENV_NAME="${1:-venv}"
VENV_DIR="$(dirname "$0")/$VENV_NAME"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "Created virtual environment '$VENV_NAME'"
else
    echo "Virtual environment '$VENV_NAME' already exists"
fi

source "$VENV_DIR/bin/activate"

if [ -f "$(dirname "$0")/requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r "$(dirname "$0")/requirements.txt"
    echo "Installed requirements from requirements.txt"
else
    echo "No requirements.txt found"
fi

