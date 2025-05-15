#!/bin/bash

version='2024.2'
cd /software/builds/intel/${version}/etc/modulefiles

rm -f .modulerc.lua
ls */* | grep -v oneapi | while read m; do
  echo "hide_modulefile(\"$m\")" >> .modulerc.lua
done
