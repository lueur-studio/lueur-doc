#!/bin/bash
# Activates the virtual environment and runs MkDocs using Python
# 
# Why this script exists:
#   On some systems (especially with multiple Python versions or shims like pyenv/jenv/rbenv),
#   running `mkdocs serve` directly may pick up a system-wide MkDocs instead of the one
#   installed in your virtual environment, causing errors like "Unrecognised theme name: 'material'".
#
#   By explicitly activating the virtual environment and using `python -m mkdocs`,
#   this script ensures the correct MkDocs version is used from the venv,
#   avoiding theme recognition issues and other environment conflicts.

DEFAULT_VENV="venv"
VENV_NAME="${1:-$DEFAULT_VENV}"
PROJECT_ROOT="$(dirname "$0")/.."
VENV_DIR="$PROJECT_ROOT/$VENV_NAME"

if [ ! -d "$VENV_DIR" ]; then
    echo "Virtual environment not found at $VENV_DIR"
    exit 1
fi

# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

cd "$PROJECT_ROOT" || exit
python -m mkdocs serve

