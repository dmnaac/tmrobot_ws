#!/bin/bash

cd /dev
sudo -S chmod -R 777 ttyUSB0 << EOF
timed
EOF
