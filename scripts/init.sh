#!/bin/bash
# Initializes a virtual environment and installs dependencies

VENV_NAME="${1:-venv}"
PROJECT_ROOT="$(dirname "$0")/.."
VENV_DIR="$PROJECT_ROOT/$VENV_NAME"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "Created virtual environment '$VENV_NAME'"
else
    echo "Virtual environment '$VENV_NAME' already exists"
fi

# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

REQ_FILE="$PROJECT_ROOT/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    pip install --upgrade pip
    pip install -r "$REQ_FILE"
    echo "Installed requirements from requirements.txt"
else
    echo "No requirements.txt found at $REQ_FILE"
fi

