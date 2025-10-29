#include "Vsinegen.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env)
{
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vsinegen *top = new Vsinegen;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sinegen.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("Lab 2: Dual SigGen"); // <-- MODIFIED for Task 2

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 1;
    top->en = 1;
    top->incr = 1;
    top->phase_offset = 0; // <-- ADDED: Initialize phase offset

    // run simulation for many clock cycles
    for (i = 0; i < 1000000; i++)
    {
        // dump variables into VCD file and toggle clock
        for (clk = 0; clk < 2; clk++)
        {
            tfp->dump(2 * i + clk);
            top->clk = !top->clk;
            top->eval();
        }

        // ++++ Send sine wave values to Vbuddy
        // MODIFIED: Plot both output signals
        vbdPlot(int(top->sig_out1), 0, 255); // Plot the first sine output
        vbdPlot(int(top->sig_out2), 0, 255); // Plot the second sine output
        
        vbdCycle(i + 1);
        // ---- end of Vbuddy output section

        // change input stimuli
        top->rst = (i < 2); // Assert reset for first 2 cycles
        top->en = 1;        // Keep enabled
        
        // MODIFIED: Read rotary encoder to set phase offset
        top->phase_offset = vbdValue(); 

        if ((Verilated::gotFinish()) || (vbdGetkey() == 'q'))
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}

