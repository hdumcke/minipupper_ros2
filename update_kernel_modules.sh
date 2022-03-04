#!/bin/bash

set -e

### Install battery monitor
cd /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/FuelGauge/
./install.sh

### Install EEPROM driver
cd /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/EEPROM
./install.sh
