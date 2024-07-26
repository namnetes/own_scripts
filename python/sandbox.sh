#!/bin/bash

#==============================================================================
# Script Name    : build_ubuntu.sh
# Description    : This script sets up the Python sandbox environment with
#                  JupyterLab.
#
# Author         : Alan MARCHAND
# Compatibility  : Bash Only
#==============================================================================

#!/bin/bash

#==============================================================================
# Script Name    : build_ubuntu.sh
# Description    : This script sets up a Python development environment with
#                  JupyterLab pre-configured for web access.
# Author         : Alan MARCHAND
# Compatibility  : Bash Only
#==============================================================================

# Define workspace directory (Modify if needed)
WORKSPACE_DIR=~/Workspace/sandbox2

# Ensure workspace directory exists
if [ ! -d "$WORKSPACE_DIR" ]; then
  echo "Creating workspace directory: $WORKSPACE_DIR"
  mkdir -p "$WORKSPACE_DIR"
fi

# Create and activate Python virtual environment
echo "Creating virtual environment..."
python3 -m venv "$WORKSPACE_DIR/venv"
source "$WORKSPACE_DIR/venv/bin/activate"

# Upgrade pip and install essential packages
echo "Upgrading pip and installing dependencies..."
python3 -m pip install --upgrade pip
python3 -m pip install jupyterlab pandas numpy seaborn requests

# Configure JupyterLab for web access
echo "Configuring JupyterLab for web access..."
JLCONFIG=~/.jupyter/jupyter_lab_config.py

# Clean-up existing configurations (if any)
rm -rf "$JLCONFIG" ~/.jupyter ~/.local/share/jupyter ~/.ipython &>/dev/null

# Generate JupyterLab configuration and disable file redirection
jupyter lab --generate-config -y
sed -i 's/^#\s\(c.ServerApp.use_redirect_file.*\)$/\1/' "$JLCONFIG"
sed -i 's/^\(c.ServerApp.use_redirect_file\s\).*$/\1= False/' "$JLCONFIG"

# Install JavaScript Kernel (Optional, for non-Python code)
echo "Checking for JavaScript Kernel..."
x=$(npm list -g ijavascript)
if [[ $? -gt 0 ]]; then
  echo "Installing JavaScript Kernel..."
  npm install -g ijavascript  # May require sudo
  cd "$WORKSPACE_DIR"
  ijsinstall
fi

# Deactivate virtual environment and return to home directory
echo "Deactivating virtual environment..."
deactivate
cd ~

echo "Python development environment with JupyterLab is ready!"