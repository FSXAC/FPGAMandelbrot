// FIXED POINT CONVENTION (32 bits)
// | 10 integer bits | 22 fraction bits |
`define INT(n) n[31:22]
`define FRAC(n) n[21:0]

module mandelbrot(
    input logic clk,
    input logic rstn,
    input logic start,
    output logic done,
    output logic [8:0] vga_x,
    output logic [7:0] vga_y,
    output logic [2:0] vga_colour,
    output logic vga_plot
);

    // Comb const values
    logic signed [31:0] w, h, xmin, xmax, ymin, ymax, dx, dy;

    // Computing the combination const values
    assign w = {10'd4, 22'b0};
    // assign h = 
endmodule