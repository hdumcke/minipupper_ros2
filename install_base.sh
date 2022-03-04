#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ssid> <wifi password>"
    exit 1
fi

############################################
# wait until unattended-upgrade has finished
############################################
tmp=$(ps aux | grep unattended-upgrade | grep -v unattended-upgrade-shutdown | grep python | wc -l)
[ $tmp == "0" ] || echo "waiting for unattended-upgrade to finish"
while [ $tmp != "0" ];do
sleep 10;
echo -n "."
tmp=$(ps aux | grep unattended-upgrade | grep -v unattended-upgrade-shutdown | grep python | wc -l)
done

### Get directory where this script is installed
BASEDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

### Give a meaningfull hostname
echo "minipupper" | sudo tee /etc/hostname

### Setup wireless networking ( must change SSID and password )

sudo sed -i "/version: 2/d" /etc/netplan/50-cloud-init.yaml
echo "    wifis:" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "        wlan0:" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "            access-points:" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "                $1:" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "                    password: \"$2\"" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "            dhcp4: true" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "            optional: true" | sudo tee -a /etc/netplan/50-cloud-init.yaml
echo "    version: 2" | sudo tee -a /etc/netplan/50-cloud-init.yaml

### upgrade Ubuntu and install required packages

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sed "s/deb/deb-src/" /etc/apt/sources.list | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt -y upgrade
sudo apt install -y bluez pi-bluetooth i2c-tools dpkg-dev curl python-is-python3

### Clone MangDang repo

mkdir -p ~/Robotics
cd ~/Robotics
git clone https://github.com/mangdangroboticsclub/QuadrupedRobot.git

### Apply patches
sed -i "s|/home/ubuntu/Music|/home/ubuntu/Robotics/QuadrupedRobot/Mangdang/stuff|" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo 25 > /sys/class/gpio/export" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo out > /sys/class/gpio/gpio25/direction" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo 1 > /sys/class/gpio/gpio25/value" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo 21 > /sys/class/gpio/export" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo out > /sys/class/gpio/gpio21/direction" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i echo 1 > /sys/class/gpio/gpio21/value" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i sleep 1" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "/^# export/i \ " /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "s|/home/ubuntu/Music|/home/ubuntu/Robotics/QuadrupedRobot/Mangdang/stuff|" /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local
sed -i "s|/sys/bus/nvmem/devices/3-00501/|/sys/bus/nvmem/devices/3-00500/|" /home/ubuntu/Robotics/QuadrupedRobot/StanfordQuadruped/calibrate_tool.py
sed -i "s|/sys/bus/nvmem/devices/3-00501/|/sys/bus/nvmem/devices/3-00500/|" /home/ubuntu/Robotics/QuadrupedRobot/StanfordQuadruped/pupper/Config.py

### Replace /boot/firmware/syscfg.txt
sudo cp /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/IO_Configuration/syscfg.txt /boot/firmware/ -f

### Install battery monitor
cd /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/FuelGauge/
chmod +x install.sh
./install.sh

### Install pip
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

### Install LCD driver
sudo apt install -y python3-dev
sudo pip install Pillow numpy spidev RPi.GPIO

### Install audio
sudo apt install -y mpg321
sudo sed -i "s/pulse/alsa/" /etc/libao.conf

### Install servo controller
sudo cp /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local /etc/
sudo cp /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/System/rc.local.service /lib/systemd/system/
sudo systemctl enable rc-local

### Install EEPROM driver
cd /home/ubuntu/Robotics/QuadrupedRobot/Mangdang/EEPROM
cp $BASEDIR/at24.c .
chmod +x install.sh
./install.sh

### Copy root calibrate script and install TK
sudo apt install -y python3-tk 
sudo cp $BASEDIR/calibrate.sh /root
