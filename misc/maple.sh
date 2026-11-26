#!/usr/bin/env bash

# this script clones and build maple mono with some flag for pure aesthetic reason 

# clone first
git clone https://github.com/subframe7536/maple-font --depth 1 -b variable
cd maple-font

# make venv 
python3 -m venv maple && pip install -r requirements.txt 

# build it
# what is this flags?
# cv02 -> double storey a 
# cv05 -> double storey g
# cv62 -> open question mark 
# cv64 -> alternative right and left arrow
# --nf for nerdfont
python build.py --nf --feat cv02,cv05,cv62,cv64 

# move them to ~/.local/share/fonts
mv fonts/NF/MapleMono-NF-*  ~/.local/share/fonts

