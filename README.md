# grove-trackball-spin
----------------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the Grove mini-trackball.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* I2C connection at up to 400kHz (unenforced)
* Relative/delta and absolute position reporting
* Manually set absolute position
* Set absolute position constraints
* Set pointer sensitivity (delta step)


## Requirements

P1/SPIN1:
* spin-standard-library
* input.pointer.common.spinh (provided by the spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* input.pointer.common.spin2h (provided by the p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1	    | SPIN1    | FlexSpin (6.8.0)	| Bytecode     | OK                    |
| P1	    | SPIN1    | FlexSpin (6.8.0)       | Native/PASM  | OK                    |
| P2	    | SPIN2    | FlexSpin (6.8.0)       | NuCode       | Not yet implemented   |
| P2        | SPIN2    | FlexSpin (6.8.0)       | Native/PASM2 | Not yet implemented   |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Limitations

* Very early in development - may malfunction, or outright fail to build

