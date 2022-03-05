Software Installation
=====================

This repository contains two installation scripts, one to install the base system, just enough to interface all hardware functionalities in software. My intention is to work upstream to get this integrated into the MangDang repository.

The second installation script installs the robot controller with a ROS2 based joystick module and a bridge that takes ROS2 joystick messages and converts them to the message format expected by the Mangdang controller. I assume that over time the community will come up with many different ways to control Mini Pupper. Consider this repository as one of many controllers.

We use ROS2 and Ubuntu. Because of ROS2 Galactic we will use Ubuntu 20.04


Workflow
--------

This is my workflow and your workflow might differ but you might have to adapt the installation scripts to your requirements.

- Flash Ubuntu server 20.04 64bit using Raspberry Pi Imager
- Connect Raspi to Ethernet cable
- Boot the newly flashed image, check IP address on DHCP server
- ssh to raspy, set password
- clone repo, run install script with SSID and wifi password as parameter
- reboot, find out IP address of wifi interface
- disconnect Ethernet cable
- ssh to wifi interface with X forwarding
- run test script
- calibrate robot (if this is the first time)
- pair PS4 controller
- Install robot controller
- reboot
- control robot with PS4 controller

Prepare SD card
---------------

Flash Ubuntu server 20.04 64bit. There are many ways to do it and probably also many different builds of the OS. I am using Raspberry Pi Imager on Mac OS and the Ubuntu images that Raspberry Pi Imager lists.

Boot Raspberry Pi with new image
--------------------------------

Put the freshly prepared SD card into the Raspberry Pi and connect to Ethernet. If you can not find out the IP address of the Raspberry Pi you can connect a screen and a keyboard to get this information.

ssh to the Raspberry Pi as user ubuntu::

  ssh ubuntu@<raspi ip address>
  
The default password is "ubuntu" and you will be asked to change it. Once you have changed the password you will be disconnected. Connect again.

Clone the repository::

  cd ~
  git clone https://github.com/hdumcke/minipupper_ros2

Install the base system
-----------------------

With and ssh connection to Raspberry Pi::

  ~/minipupper_ros2/install_base.sh <my SSID> <my wifi password>
  
Reboot at the end of the installation. 

Upgrade kernel modules
----------------------

It is possible that the previous installation step upgraded the kernel but compiled the kernel driver with an old kernel.

To upgrade the kernel modules run::

   ~/minipupper_ros2/update_kernel_modules.sh

Reboot again. 
  
Test the base system
--------------------

While the installation so far could have been done when the Raspberry Pi has not been connected to the Mini Pupper now you have to make sure you test with the real hardware.

Run the test script::

  ~/minipupper_ros2/test_base.sh
  
and follow the instructions. The test script will exercise all hardware functions to ensure you have a working system. The trouble shooting section might have some additional information in case your system does not work as expected.

Calibrate and connect PS4 controller
------------------------------------

You can do this now or later. Details are in the configuration section of this document.

Install Robot Controllers
-------------------------

To install the joy stick controller and the MangDang Mini Puuper controller::

  ~/minipupper_ros2/install_robot.sh
  
at the end of the installation reboot. After calibration and connecting the PS4 controller you should be able to move Mini Pupper with the PS4 controller.
