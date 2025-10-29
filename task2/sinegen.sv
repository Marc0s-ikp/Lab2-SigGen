module sinegen(
    input  logic       clk,            // system clock
    input  logic       rst,            // system reset
    input  logic       en,             // enable signal
    input  logic [7:0] incr,           // Frequency control
    input  logic [7:0] phase_offset,   // Phase offset from Vbuddy
    output logic [7:0] sig_out1,       // Output signal 1
    output logic [7:0] sig_out2        // Output signal 2 (phase offset)
);

    // Counter instance for the first address (addr1)
    logic [7:0] addr1;
    counter #(.WIDTH(8)) u_counter (
        .clk(clk),
        .rst(rst),
        .en(en),
        .incr(incr),
        .count(addr1)
    );

    // Calculate the second address (addr2) by adding the offset
    // 8-bit addition naturally handles the phase wraparound
    logic [7:0] addr2;
    assign addr2 = addr1 + phase_offset;

    // Dual-Port ROM instance
    // Note the new ports: addr1, addr2, data1, data2
    rom u_rom (
        .clk(clk),
        .addr1(addr1),
        .addr2(addr2),
        .data1(sig_out1), // Connected to sig_out1
        .data2(sig_out2)  // Connected to sig_out2
    );

endmodule
