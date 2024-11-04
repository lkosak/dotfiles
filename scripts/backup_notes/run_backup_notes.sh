#!/bin/bash

# Define paths
SCRIPT_DIR="$(dirname "$0")" # Change to the directory where your Python script is located
VENV_DIR="$HOME/local_python_env"          # Virtual environment directory
PYTHON_SCRIPT="$SCRIPT_DIR/backup_notes.py"   # Path to your Python script

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Run the Python script
python3 "$PYTHON_SCRIPT"

# Deactivate the virtual environment
deactivate
