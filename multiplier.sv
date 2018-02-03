// Custom multiplier for fixed point
// 10 bit integer, 22 bit fractions
module multiplier(in, out);
    input logic signed [31:0] in;
    output logic signed [31:0] out;

    parameter multiplier = 32'b0;

    logic [63:0] product;

    assign product = multiplier * in;

    assign out = product[53:22];
endmodule