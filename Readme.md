# FPGA Assignment: some fun with FPGA VGA output.

*Just an average guy who serves an average assignment.*

![Build Pass](https://img.shields.io/badge/build-success-brightgreen.svg)

## You have to know

This project is designed based on the requirement for function 4, which will use the container framework to organize function 1 to function 3. If you have no idea with the source code, please check the [Documentation](doc/Home.md) to get start with.

## Preparations

You have to let the system could find `iverilog`, `vvp` and `gtkwave` from command.

To test this, you have to launch a `cmd` and try to launch all these command. If the `cmd` said that any of these command `is not recognized as an internal or external command, operable program or batch file`, you have to check the `path` environment variable. It should contains the directory which have those three files.

## Compile

Clone the whole repository to your local disk, and then open `cmd` or terminal and `cd` to the project folder. Type

	make

to compile the project.

## Simulation

Use `vvp` to simulate the project.

	vvp a.out

And use `gtkwave` to show the waveform.

	gtkwave TB_vgadriver.vcd

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.