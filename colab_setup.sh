#!/bin/bash

# 1. Install all the python packages from our fixed requirements file
echo "--- Installing Python packages ---"
pip install -r requirements.txt

# 2. Automatically find and patch the skvideo library to fix numpy errors
echo "--- Patching skvideo library ---"
# Find the path to the ffmpeg.py file, no matter where Colab installs it
FILE_TO_PATCH=$(python -c "import skvideo.io; print(skvideo.io.__file__.replace('__init__.py', 'ffmpeg.py'))")

if [ -f "$FILE_TO_PATCH" ]; then
    echo "Found ffmpeg.py at: $FILE_TO_PATCH"
    # Apply the patches to fix np.float and np.int
    sed -i 's/np.float/float/g' "$FILE_TO_PATCH"
    sed -i 's/np.int/int/g' "$FILE_TO_PATCH"
    echo "Patches applied successfully."
else
    echo "ERROR: Could not find ffmpeg.py to patch."
fi
