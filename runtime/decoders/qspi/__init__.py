##
## This file is part of the libsigrokdecode project.
##
## Copyright (C) 2023 ALIENTEK(正点原子) <39035605@qq.com>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, see <http://www.gnu.org/licenses/>.
##

'''
QSPI (Quad Serial Peripheral Interface) is a serial communication protocol widely used 
in microcontrollers and embedded systems. 
It enhances data transfer speeds and efficiency by employing four data lines for communication: 
Quad MOSI (QSPI-MOSI), Quad MISO (QSPI-MISO), Serial Clock (QSPI-SCLK), and Slave Select (QSPI-SS). 

Compared to the traditional SPI (Serial Peripheral Interface) protocol, 
which utilizes only two data lines, 
QSPI enables simultaneous transmission of four data bits, 
resulting in significantly faster data transfer rates.
'''

from .pd import Decoder
