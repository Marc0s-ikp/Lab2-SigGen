module rom #(
    parameter   ADDRESS_WIDTH = 8,
                DATA_WIDTH    = 8
)(
    input logic                 clk,
    input logic [ADDRESS_WIDTH-1:0] addr1,  // Address for port 1
    input logic [ADDRESS_WIDTH-1:0] addr2,  // Address for port 2
    output logic [DATA_WIDTH-1:0]   data1,  // Data from port 1
    output logic [DATA_WIDTH-1:0]   data2   // Data from port 2
);

    logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];
    initial begin
        $display("Loading ROM ... ");
        $readmemh("task1/sinerom.mem", rom_array); 
    end;

    // Synchronous read for BOTH ports
    always_ff @(posedge clk) begin
        data1 <= rom_array[addr1];
        data2 <= rom_array[addr2];
    end

endmodule
