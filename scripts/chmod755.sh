#!/bin/bash

find ~/.leovim.d/jetpack -type f | grep update_tags.sh$ | xargs chmod 755
find ~/.leovim.d/plug    -type f | grep update_tags.sh$ | xargs chmod 755
