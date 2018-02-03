// Custom multiplier for fixed point
// 10 bit integer, 22 bit fractions
module multiplier(a, b, out);
    input logic signed [31:0] a, b;
    output logic signed [31:0] out;

    logic [63:0] product;

    assign product = a * b;

    assign out = product[53:22];
endmodule