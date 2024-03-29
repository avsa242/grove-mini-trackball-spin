{
    --------------------------------------------
    Filename: input.pointer.grove-mini-trackball.spin
    Author: Jesse Burt
    Description: Driver for the Grove mini trackball
    Copyright (c) 2024
    Started Jan 1, 2024
    Updated Jan 2, 2024
    See end of file for terms of use.
    --------------------------------------------
}

#include "input.pointer.common.spinh"           ' pull in code common to all pointing drivers

CON

    SLAVE_WR    = core.SLAVE_ADDR
    SLAVE_RD    = core.SLAVE_ADDR|1

    DEF_SCL     = 28
    DEF_SDA     = 29
    DEF_HZ      = 100_000
    DEF_ADDR    = 0
    I2C_MAX_FREQ= core.I2C_MAX_FREQ

    { default I/O settings; these can be overridden in the parent object }
    SCL         = DEF_SCL
    SDA         = DEF_SDA
    I2C_FREQ    = DEF_HZ
    I2C_ADDR    = DEF_ADDR

OBJ

{ decide: Bytecode I2C engine, or PASM? Default is PASM if BC isn't specified }
#ifdef GROVE_MINI_TRACKBALL_I2C_BC
    i2c:    "com.i2c.nocog"
#else
    i2c:    "com.i2c"
#endif
    core:   "core.con.grove-mini-trackball"
    time:   "time"


PUB null()
' This is not a top-level object

PUB start(): status
' Start using "standard" Propeller I2C pins and 100kHz
    return startx(SCL, SDA, I2C_FREQ)


PUB startx(SCL_PIN, SDA_PIN, I2C_HZ): status
' Start using custom IO pins and I2C bus frequency
    if ( lookdown(SCL_PIN: 0..31) and lookdown(SDA_PIN: 0..31) )
        if ( status := i2c.init(SCL_PIN, SDA_PIN, I2C_HZ) )
            time.usleep(core.T_POR)
            if ( i2c.present(SLAVE_WR) )
                i2c.stop()
                return
    ' if this point is reached, something above failed
    ' Re-check I/O pin assignments, bus speed, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE

PUB stop()
' Stop the driver
    i2c.deinit()


PUB defaults()
' Set factory defaults


PUB read_x = pointer_rel_x
PUB pointer_rel_x(): x
' Get the pointer relative position (delta), X-axis
'   Returns: position relative to the last reading (signed 8-bit)

    { get the total horizontal delta by subtracting the LEFT reg, and adding the RIGHT reg }
    x := 0
    x -= rd_byte(core.LEFT)
    x += rd_byte(core.RIGHT)
    x := ~x / _pointer_x_sens                  ' extend sign, scale to sensitivity

    { update the pointer absolute position and clamp to set limits }
    _pointer_x := _pointer_x_min #> (_pointer_x + x) <# _pointer_x_max


PUB read_y = pointer_rel_y
PUB pointer_rel_y(): y
' Get the pointer relative position (delta), Y-axis
'   Returns: position relative to the last reading (signed 8-bit)

    { get the total vertical delta by subtracting the UP reg, and adding the DOWN reg }
    y := 0
    y -= rd_byte(core.UP)
    y += rd_byte(core.DOWN)
    y := ~y / _pointer_y_sens                  ' extend sign, scale to sensitivity

    { update the pointer absolute position and clamp to set limits }
    _pointer_y := _pointer_y_min #> (_pointer_y + y) <# _pointer_y_max


PRI rd_byte(r): b

    i2c.start()
    i2c.write(SLAVE_WR)
    i2c.write(core.READ_MODE)
    i2c.write(r)
    i2c.write(1)
    i2c.stop()

    i2c.start()
    i2c.write(SLAVE_RD)
    b := i2c.rd_byte(i2c.NAK)
    i2c.stop()


PRI writereg(reg_nr, ptr_buff, len)

    i2c.start()
    i2c.write(SLAVE_WR)
    i2c.write(core.WRITE_MODE)
    i2c.write(reg_nr)
    i2c.wrblock_lsbf(ptr_buff, len)
    i2c.stop()

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

