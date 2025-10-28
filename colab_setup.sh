#!/bin/bash

# 1. Unzip the model weights that are included in the repository
echo "--- Unzipping local model files ---"
unzip RIFE_trained_model_v3.6.zip

# 2. Install all the python packages from our fixed requirements file
echo "--- Installing Python packages ---"
pip install -r requirements.txt

# 3. Automatically find and patch the skvideo library to fix numpy errors
echo "--- Patching skvideo library ---"
FILE_TO_PATCH=$(python -c "import skvideo.io; print(skvideo.io.__file__.replace('__init__.py', 'ffmpeg.py'))")

if [ -f "$FILE_TO_PATCH" ]; then
    echo "Found ffmpeg.py at: $FILE_TO_PATCH"
    sed -i 's/np.float/float/g' "$FILE_TO_PATCH"
    sed -i 's/np.int/int/g' "$FILE_TO_PATCH"
    echo "Patches applied successfully."
else
    echo "ERROR: Could not find ffmpeg.py to patch."
fi

echo "--- Setup complete! ---"
