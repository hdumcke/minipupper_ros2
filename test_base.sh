#!/bin/bash

check_result () {

read -r -p "$1? [Y/n] " input

case $input in
      ([yY][eE][sS]|[yY]|'')
            return
            ;;
      *)
            echo "Check your installation..."
            exit 1
            ;;
esac

}

### Test battery monitor
current_voltage=`cat /sys/class/power_supply/max1720x_battery/voltage_now`
echo "The current voltage is $current_voltage"

check_result "Did it display the current voltage"

### Test LCD driver
cd /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/Example/display
sudo python demo.py
check_result "Do you see the dog on the LCD diplay"

### Test audio
sudo mpg123 /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/stuff/power_on.mp3
check_result "Did you hear a sound"

### Test EEPROM driver
sudo hexdump /sys/bus/nvmem/devices/3-00500/nvmem
check_result "Did you see a hex dump"

### Test servo
echo "Warning: the next test will move a leg. Please hold Minipupper in our hand"
check_result "Ready"

echo 1500000 | sudo tee /sys/class/pwm/pwmchip0/pwm4/duty_cycle
sleep 2
echo 2500000 | sudo tee /sys/class/pwm/pwmchip0/pwm4/duty_cycle

check_result "Did you see a leg moving"

echo "Your base installation looks OK"
echo "You may now proceed to calibrate Minipupper"
