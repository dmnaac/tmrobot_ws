#!/bin/bash

# Get the current date and time
current_date_time=$(date +"%Y-%m-%d_%H-%M-%S")

map_root="${HOME}/cartographer_ws/map"
map_name="$current_date_time"

lua_root="${HOME}/cartographer_ws/cartographer_ros_ws/src/
         cartographer_ros/cartographer_ros/configuration_files"
lua_name="tmrobot_2d.lua"

# Check if map folder exists, if not create one.
if [ ! -d "$map_root" ];then
    echo "map folder does not exist, creating this folder"
    mkdir -p $map_root
fi

map_dir="$map_root/$map_name"

# Create a directory with the current date and time as its name
mkdir "$map_dir"

lua_dir="$lua_root/$lua_name"

# Copy the lua file to the new map folder
cp "$lua_dir" "$map_dir"
echo "lua file for this map has been copied"

# Finish slam
rosservice call /finish_trajectory 0

# Make pbstream
rosservice call /write_state "{filename: '$map_dir/$map_name.pbstream'}"

# Convert pbstream to map
rosrun cartographer_ros cartographer_pbstream_to_ros_map \
-pbstream_filename=$map_dir/$map_name.pbstream \
-map_filestem=$map_dir/$map_name