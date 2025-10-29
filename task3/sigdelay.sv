module sigdelay(
    input  logic       clk,
    input  logic       rst,
    input  logic       wr,           
    input  logic       rd,           
    input  logic [7:0] mic_signal,   // Audio sample from Vbuddy
    input  logic [8:0] offset,       // Delay offset from Vbuddy
    output logic [7:0] delayed_signal // Delayed sample to Vbuddy
);

    // 9-bit address bus for 512 locations (2^9 = 512)
    logic [8:0] write_addr;
    logic [8:0] read_addr;

    // 1. Instantiate the counter
    // The counter's 'en' port is driven by the 'wr' signal
    counter #(.WIDTH(9)) u_counter (
        .clk(clk),
        .rst(rst),
        .en(wr),      // <-- Use 'wr' as the enable
        .incr(9'd1),
        .count(write_addr)
    );

    // 2. Calculate the "read head" address
    assign read_addr = write_addr + offset;

    // 3. Instantiate the Dual-Port RAM
    // The RAM's 'write_en' port is also driven by 'wr'
    ram #(.ADDRESS_WIDTH(9), .DATA_WIDTH(8)) u_ram (
        .clk(clk),
        .write_en(wr), // <-- Use 'wr' as the write enable
        .write_addr(write_addr),
        .data_in(mic_signal),
        .read_addr(read_addr),
        .data_out(delayed_signal)
    );

    // 'rd' is an input but not connected to anything,
    // which satisfies the testbench.

endmodule

