# Copyright 2016 Open Source Robotics Foundation, Inc.
# Copyright 2022 Horst Dumcke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import rclpy
from rclpy.node import Node

from sensor_msgs.msg import Joy
import sys
import time
sys.path.append("/home/ubuntu/Robotics/QuadrupedRobot/UDPComms")
from UDPComms import Publisher


class MinimalSubscriber(Node):

    def __init__(self):
        super().__init__('minimal_subscriber')
        self.subscription = self.create_subscription(
            Joy,
            'joy',
            self.listener_callback,
            10)
        self.subscription  # prevent unused variable warning
        self.message_rate = 20
        self.joystick_pub = Publisher(8830,65530)

    def listener_callback(self, msg):

        left_y = -msg.axes[1]
        right_y = -msg.axes[4]
        right_x = msg.axes[3]
        left_x = msg.axes[0]
    
        L2 = msg.buttons[6]
        R2 = msg.buttons[7]
    
        R1 = msg.buttons[5]
        L1 = msg.buttons[4]
    
        square = msg.buttons[3]
        x = msg.buttons[0]
        circle = msg.buttons[1]
        triangle = msg.buttons[2]
    
        dpadx = msg.axes[6]
        dpady = msg.axes[7]
    
        msg_pub = {
            "ly": left_y,
            "lx": left_x,
            "rx": right_x,
            "ry": right_y,
            "L2": L2,
            "R2": R2,
            "R1": R1,
            "L1": L1,
            "dpady": dpady,
            "dpadx": dpadx,
            "x": x,
            "square": square,
            "circle": circle,
            "triangle": triangle,
            "message_rate": self.message_rate,
        }
        self.joystick_pub.send(msg_pub)

        self.get_logger().debug('I heard: "%s"' % msg_pub)

        time.sleep(1 / self.message_rate)


def main(args=None):
    rclpy.init(args=args)

    minimal_subscriber = MinimalSubscriber()

    rclpy.spin(minimal_subscriber)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    minimal_subscriber.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
