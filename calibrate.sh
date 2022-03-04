#!/bin/bash

[ -d "/opt/ros/galactic" ] && source /opt/ros/galactic/setup.bash
cp /home/ubuntu/.Xauthority /root
export DISPLAY=localhost:10.0
python /home/ubuntu/Robotics/QuadrupedRobot/StanfordQuadruped/calibrate_tool.py
