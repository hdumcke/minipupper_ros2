Low Level Interfaces
====================

Mini Pupper provides a PCB board that connects to the 40 Pin GPIO pins of a Raspberry Pi. The expansion board are connected to a LDC screen, the servo motors, the battery and a cooling fan. The expansion board also has a low quality loud speaker allowing to provide audible feedback. The expansion board also provides an EEPROM to store persistent data.

We can now look look how the main hardware features are exposed to the software layer.

Battery Interface
-----------------

The PCB board provides power to the Raspberry Pi but also provides an interface to check the battery level. The interface uses the i2c protocol and requires that the max1720x_battery diver is loaded. This driver is not part of the standard Ubuntu kernel for Raspberry Pi but source code is provided by Mandang. Updating the kernel on the robot also requires a recompilation and reinstallation of the kernel.

The interface is activated with a device tree overlay. This is the line::

  dtoverlay=i2c4,pins_6_7
  
in /boot/firmware/syscfg.txt The kernel driver exposes /sys/class/power_supply/max1720x_battery/voltage_now in the Linux virtual file system and the actual voltage level can be read with "cat /sys/class/power_supply/max1720x_battery/voltage_now"

MangDang provides a daemon that monitor the voltage and disable the servo interfaces when the voltage is below a certain threshold.

Monitoring the charge of a LiPO is crucial to avoid fire hazard and this battery gauge is independent from the other software that commands the robot.

LDC Interface
-------------

The LCD interface uses the SPI protocol. SPI is activated with a device tree overlay. This is the line::

  dtoverlay=spi0-1cs

in /boot/firmware/syscfg.txt. To drive the LCD screen we use a ST7789 driver in QuadrupedRobot/Mangdang/LCD. You can find example code in QuadrupedRobot/Mangdang/Example/display

Audio
-----

We use mpg321, a "Simple and lightweight command line MP3 player" to produce sound. 

The mapping of the audio device to the speaker on the PCB board is done with the lines::

  dtparam=audio=on
  dtoverlay=audremap,pins_18_19

in /boot/firmware/syscfg.txt.

Servo Controller
----------------

Servos are controlled using pulse-width modulation (PWM). We first have to enable the GPIO headers::

  echo 25 > /sys/class/gpio/export
  echo out > /sys/class/gpio/gpio25/direction
  echo 1 > /sys/class/gpio/gpio25/value
  echo 21 > /sys/class/gpio/export
  echo out > /sys/class/gpio/gpio21/direction
  echo 1 > /sys/class/gpio/gpio21/value

Then we set up the PWM interface with::

  for i in $(seq 0 15)
  do
          echo $i > /sys/class/pwm/pwmchip0/export
          echo  4000000 > /sys/class/pwm/pwmchip0/pwm$i/period
  done

This is done at boot time with the rc.local daemon. The original MangDang software enables the GPIO headers for the servos in the battery_monitor service.

EEPROM
------

To read from and write to the non-volatile storage on the PCB board we need the at24 kernel driver. This driver is part of the Linux kernel source tree but not compiled for the Ubuntu 20.04 version we are using with the Raspberry Pi. You can get the code by checking out the kernel source code::

  sed "s/# deb-src/deb-src/" /etc/apt/sources.list | sudo tee -a /etc/apt/sources.list
  sudo apt update
  sudo apt upgrade
  apt-get source linux-image-$(uname -r)

The recent version of the source for the at24 is included in the repository so that you only have to check out kernel source tree if you encounter any issues.

The interface is activated with a device tree overlay. This is the line::

  dtoverlay=i2c3,pins_4_5

in /boot/firmware/syscfg.txt

If correctly installed we should see a file /sys/bus/nvmem/devices/3-00500/nvmem. Reading and writing data to this file will make the data persist even when we reformat the memory card.

This non-volatile memory is used to store calibration data. We could also use a file on the SD card like /home/ubuntu/Robotics/nvmem as persistent storage. This would remove the need to having to compile the kernel driver but we would have to calibrate the robot each time we reformat the SD card. Since calibration data are hardware dependent it makes sense to store with the hardware but when we do simulation where we do not have real hardware we have to find a work around.
