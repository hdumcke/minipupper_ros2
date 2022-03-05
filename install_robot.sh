#!/bin/bash

### Get directory where this script is installed
BASEDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

### Add user to input group
sudo adduser $USER input

### Install required Python packages
sudo pip install msgpack transforms3d

### Install ROS2
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update
sudo apt install -y ros-galactic-ros-base python3-rosdep2 python3-colcon-common-extensions ros-galactic-joy
echo "source /opt/ros/galactic/setup.bash" >> ~/.bashrc
source /opt/ros/galactic/setup.bash
rosdep update

### create ROS2 workspace and compile modules
mkdir -p ~/minipupper_ws/src
cd ~/minipupper_ws/src
ln -s $BASEDIR/minipupper_bringup .
ln -s $BASEDIR/minipupper_command .
cd ~/minipupper_ws
source /opt/ros/galactic/setup.bash
colcon build

### Install supervisor and startup scripts
sudo apt install -y supervisor
cd $BASEDIR/Supervisor
./install.sh

