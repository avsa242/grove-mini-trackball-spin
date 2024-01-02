{
    --------------------------------------------
    Filename: Grove-mini-trackball-demo-EVE.spin
    Author: Jesse Burt
    Description: Demo of the Grove I2C mini-trackball
        * EVE display output
    Copyright (c) 2024
    Started Jan 1, 2024
    Updated Jan 2, 2024
    See end of file for terms of use.
    --------------------------------------------
}
' Uncomment the below lines to use the bytecode-based I2C engine
'#define GROVE_MINI_TRACKBALL_I2C_BC
'#pragma exportdef(GROVE_MINI_TRACKBALL_I2C_BC)

CON

    _clkmode    = cfg#_clkmode
    _xinfreq    = cfg#_xinfreq


' Uncomment one of the following, depending on your display size/resolution
'   NOTE: WIDTH, HEIGHT, XMAX, YMAX, CENTERX, CENTERY symbols are defined
'   in the display timings file.
#include "eve3-lcdtimings.800x480.spinh"
'#include "eve3-lcdtimings.480x272.spinh"
'#include "eve3-lcdtimings.320x240.spinh"
'#include "eve3-lcdtimings.320x102.spinh"

OBJ

    cfg:        "boardcfg.flip"
    ser:        "com.serial.terminal.ansi" | SER_BAUD=115_200
    time:       "time"
    lcd:        "display.lcd.bt81x" | CS=0, SCK=1, MOSI=2, MISO=3, RST=4
    pointer:    "input.pointer.grove-mini-trackball.spin" | SCL=28, SDA=29, I2C_FREQ=100_000


PUB main() | i

    setup()

    pointer.set_abs_x_max(WIDTH-1)
    pointer.set_abs_y_max(HEIGHT-1)
    pointer.set_abs_x_min(0)
    pointer.set_abs_y_min(0)
    pointer.set_sensitivity_x(8)
    pointer.set_sensitivity_y(8)
    pointer.set_abs_x(WIDTH/2)
    pointer.set_abs_y(HEIGHT/2)

    repeat
        pointer.read_x()
        pointer.read_y()
        ser.pos_xy(0, 5)
        ser.printf2(@"x: %5.5d    y: %5.5d", pointer.abs_x(), pointer.abs_y())

        lcd.wait_rdy()
        lcd.dl_start()
            lcd.clear_screen(0)
            lcd.color_rgb24($ff_ff_ff)
            lcd.point_size(16*10)
            lcd.plot(pointer.abs_x(), pointer.abs_y())
        lcd.dl_end()

PUB setup()

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( lcd.start(@_disp_setup) )
        ser.strln(@"EVE started")
    else
        ser.strln(@"EVE failed to start")
        repeat

    if ( pointer.start() )
        ser.strln(@"Trackball driver started")
    else
        ser.strln(@"Trackball driver failed to start - halting")
        repeat

DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

