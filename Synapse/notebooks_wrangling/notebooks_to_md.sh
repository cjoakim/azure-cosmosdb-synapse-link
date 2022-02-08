#!/bin/bash

# Parse the *.ipynb files in the ../notebooks/ directory into
# more readable markdown content.
# Chris Joakim, Microsoft

listfile="tmp/notebooks_list.txt"
ls ../notebooks/*.ipynb > $listfile

source venv/bin/activate
python --version

python main.py notebooks_to_md $listfile

echo 'done'
