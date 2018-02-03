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

    // ======= [ COMB CONST & COMB CONST COMPUTATIONS ] =======
    logic signed [31:0] w, h, xmin, xmax, ymin, ymax, dx, dy;

    // Computing the combination const values
    assign w = {10'd4, 22'b0};

    // h = w * 0.75
    multiplier M0(.a(w), .b({10'b0, 2'b11, 20'b0}), .out(h));

    // xmin = w * -0.5 = w / 2 * -1
    assign xmin = (w >> 1) * ~(32'b0);

    // xmax = xmin + w
    assign xmax = xmin + w;

    // ymin = h * -0.5 = h / 2 * -1
    assign ymin = (h >> 1) * ~(32'b0);

    // ymax = ymin + h
    assign ymax = ymin + h;

    // dx = 0.003125 * (xmax - xmin)
    multiplier M1(
        .a(xmax - xmin),
        .b({10'b0, 22'b0000000011001100110011}),
        .out(dx)
    );

    // dy = 0.0041666666... * (ymax - ymin)
    multiplier M2(
        .a(ymax - ymin),
        .b({10'b0, 22'b0000000100010001000100}),
        .out(dy)
    );

    // ====== [ CONSTS ] ======
    logic [31:0] iterations, max_distance;
    assign iterations = 32'd16;
    assign max_distance = 32'd16;

    // ====== [ REGISTERS ] ======
    

endmodule