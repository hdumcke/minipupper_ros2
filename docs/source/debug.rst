Trouble Shooting
================

This section contains an incomplete list of things to check

First make sure that your kernel drivers are up to date with the current kernel version::

  ~/minipupper_ros2/update_kernl_modules.sh
  sudo reboot

Check service status
--------------------

Check systemd services::

  sudu systemctl status battery_monitor
  sudo systemctl status rc.local

Check supervisor services::

  tail /var/log/supervisor/supervisord.log
  tail /var/log/supervisor/ros-minipupper.log
  tail /var/log/supervisor/mangdang-minipupper.log

Check battery monitor
---------------------

Check status of the service::

  sudo systemctl status battery_monitor

Check if battery status is exposed via the kernel::

  /sys/class/power_supply/max1720x_battery

Check if kernel module is loaded::

  lsmod | grep max1720x_battery

Check LCD driver
----------------

Check if SPI device exists::

  ls /dev/spidev0.0

Check audio
-----------

To play a sound::

  mpg123 /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/stuff/power_on.mp3

Check servo controller
----------------------

Check if GPIO pins are configured::

  ls /sys/class/gpio/gpio25
  ls /sys/class/gpio/gpio21

Check if PWM is configured::

  ls /sys/class/pwm/pwmchip0/pwm*

Check EEPROM driver
-------------------

Check if nvmem is exposed via the kernel::

  ls /sys/bus/nvmem/devices/
  ls /sys/bus/nvmem/devices/3-00500/nvmem

Check if kernel module is loaded::

  lsmod | grep at24

Check Joystick Controller
-------------------------

Check if device exists::

  ls /dev/input/js0

Check if ROS node exists::

  ros2 node list
  
You should see a node /joy_node

Check if you can see joystick messages::

  ros2 topic echo /joy
  
You should see joystick messages when you use the joystick
