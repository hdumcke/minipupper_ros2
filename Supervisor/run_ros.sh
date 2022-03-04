#!/bin/bash

export HOME=/home/ubuntu
source /opt/ros/galactic/setup.bash
source /home/ubuntu/minipupper_ws/install/setup.bash
# clean log files
rm -rf /home/ubuntu/.ros/log/*
ros2 launch minipupper_bringup minipupper_hw.launch.py
