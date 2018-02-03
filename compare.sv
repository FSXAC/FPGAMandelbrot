// Custom multiplier for fixed point
// 10 bit integer, 22 bit fractions

`define LT 2'b00
`define GT 2'b01
`define EQ 2'b10

module compare(a, b, out);
    input logic signed [31:0] a;
    input logic signed [31:0] b;
    output logic [1:0] out;

    always_comb begin
        if (`INT(a) > `INT(b)) out = 
    end
endmodule