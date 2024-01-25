#!/bin/bash
cd build
make
cd ..
echo "Enter commit message"
read msg
git add .
git commit -m "$msg"
git push