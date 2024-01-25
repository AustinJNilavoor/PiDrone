#!/bin/bash
cd build
make
cd ..
echo "\n enter msg "
read msg
git add .
git commit -m "$msg"
git push