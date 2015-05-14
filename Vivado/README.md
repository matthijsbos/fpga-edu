#  Vivado Source files #
This folder contains all files necessairy by the Xilinx Vivado IDE. This project was created using Vivado version 2015.1.

## Installation ##
1. Open Vivado
2. Open the TCL console and navigate to the directory that contains the build.tcl file `$ cd <git checkout dir>/Vivado/`
3. Execute the `build.tcl` file using `$ source build.tcl`
4. Vivado will regenerate the project in the `<git checkout dir>/Vivado/fpga-edu` directory.

## Development ##
New source files are to be added remotely of the Vivado project, adding a reference to a file in `<git checkout dir>/Vivado/src/...` or `<git checkout dir>/Vivado/ip/...`

New IP is to be added using the standalone "Manage IP" option on the Vivado IDE start page. 

Everytime a file is added to the project using the Vivado IDE, please regenerate the `build.tcl` file using "File">"Write Project Tcl". 