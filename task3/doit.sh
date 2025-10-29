#!/bin/bash

#cleanup
rm -rf obj_dir
rm -f counter.vcd

~/Documents/iac/lab0-devtools/tools/attach_usb.sh

#compile and run
 verilator -Wall --cc --trace sigdelay.sv counter.sv rom.sv --exe sigdelay_tb.cpp
make -j -C obj_dir/ -f Vsigdelay.mk Vsigdelay


obj_dir/Vsigdelay