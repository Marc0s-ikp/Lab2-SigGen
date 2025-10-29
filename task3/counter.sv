module counter #(
    parameter WIDTH = 8
)(
    //interface signals
    input  logic                 clk,   //clock
    input  logic                 rst, //reset
    input  logic                 en,    // counter enable
    input  logic [WIDTH-1:0]     incr,  // counter increment
    output logic [WIDTH-1:0]     count  // counter output
);

always_ff @(posedge clk or posedge rst)
    if (rst) count <= {WIDTH{1'b0}}; // concatenation to form WIDTH bits of zeros
    else if (en)
        count <= count + incr; // increment counter

endmodule
