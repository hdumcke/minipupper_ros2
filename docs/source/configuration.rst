Configuration
=============

In order to use Mini Pupper with a PS4 controller you have to calibrate your Mini Pupper and you have to connect your joystick

Pair PS4 Controller
-------------------

Put bluetooth in scan mode. Put the controller in pairing mode. Detect Mac address of controller when it shows up on the raspberry Pi in scan mode. Pair, connect and trust the controller.

To set the controller in pairing mode press the “PlayStation” button and the “Share” button on the controller at the same time, and hold them down. The light bar on the back of the controller should begin flashing, indicating that it’s in pairing mode.

ssh to Mini Pupper and enter the following commands::

  bluetoothctl
  scan on
  pair 00:00:00:00:00:00
  connect 00:00:00:00:00:00
  trust 00:00:00:00:00:00
  exit
  
where 00:00:00:00:00:00 is the Mac address of the controller as discovered by the scan

Calibrate Mini Pupper
---------------------

Follow the official MangDang documentation on how to calibrate. The calibration tool uses a graphical user interface and must run as root. To use is in headless mode connect with X forwarding::

  ssh -Y ubuntu@pupper
  
assuming you have a DNS entry pupper pointing to the IP address or you replace with your actual IP address.

Now start the calibration tool::

  sudo su -
  ./calibrate.sh
