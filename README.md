# Mini Pupper

Trying to make <a href="https://github.com/mangdangroboticsclub/QuadrupedRobot"">MangDang Mini Pupper</a> to do what I want him to do

![Mini Pupper](https://raw.githubusercontent.com/mangdangroboticsclub/QuadrupedRobot/MiniPupper_V2/Doc/imgs/MiniPupper.png)

## Objective

Install Ubuntu 20.04 in Raspberry Pi and then install all required software from source

## Difference between this repo and https://github.com/mangdangroboticsclub/QuadrupedRobot

When I reveiced my Mini Pupper end of January 2022 the recommended procedure to install the software was to download an image from a Google drive and flash a memory card. This image did not work with my PS4 controller and running "apt upgrade" was creating kernel driver issues. And my goal was also to fully inderstand the software that controls the robot to conduct my own research, hence this repository.

The differences are mainly:

- replaces the joystick controller with the joystick controller from ROS2
- provides a bridge to convert messages from the ROS2 topic /joy to UDPComms
- provides a build script that installes everything from source code
- provides documentation for low level hardware interfaces as a starting point for alternate controllers
- allow to run the callibration tool headless, no need to connect a monitor to the Raspberry Pi during installation

## Documentation

Build the documentation in a Python virtual environment with sphinx installed via pip. Run "make html" in the doc dirctory and open docs/build/html/index.html

## Status

Starting with Ubuntu Server 20.04.4 LTS flashed to a memory card the install script will result in a modified installation of the MangDang software. The only component that is not yet open source is MovementScheme.so and GaitScheme.so provided by MangDang but you can use lower level interfaces to write your own controller.

I expect the MangDang software to improve and I am working upstream to make this happen

## Future Plans

Check out the details in the documentation for details:

- Visualtisation with RViz
- Simulation with PyBullet
- Alternate gait controllers
- Tighter integration into the ROS2 framework

