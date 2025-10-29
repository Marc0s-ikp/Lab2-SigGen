module ram #(
    parameter ADDRESS_WIDTH = 9,
    parameter DATA_WIDTH  = 8
)(
    input  logic                       clk,
    // Write Port
    input  logic                       write_en,
    input  logic [ADDRESS_WIDTH-1:0]   write_addr,
    input  logic [DATA_WIDTH-1:0]      data_in,
    // Read Port
    input  logic [ADDRESS_WIDTH-1:0]   read_addr,
    output logic [DATA_WIDTH-1:0]      data_out
);

    // This is the RAM array: 512 entries, each 8 bits wide
    logic [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0];

    // Synchronous Write Port
    always_ff @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= data_in;
        end
    end

    // Synchronous Read Port
    // The output is registered, which is good practice.
    always_ff @(posedge clk) begin
        data_out <= mem[read_addr];
    end

endmodule
