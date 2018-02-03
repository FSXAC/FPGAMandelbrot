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
    logic [15:0] iterations, max_distance;
    assign iterations = 32'd16;
    assign max_distance = 32'd16;

    // ====== [ REGISTERS ] ======
    // Register connections
    logic enx, eny, ena, enb, enn, eni, enj;
    logic signed [31:0] x, y, a, b;
    logic signed [31:0] x_new, y_new, a_new, b_new;
    logic [15:0] n, i, j;
    logic [15:0] n_new, i_new, j_new;

    // Registers
    register R0(.d(x_new), .q(x), .en(enx), .clk(clk));
    register R1(.d(y_new), .q(y), .en(eny), .clk(clk));
    register R2(.d(a_new), .q(a), .en(ena), .clk(clk));
    register R3(.d(b_new), .q(b), .en(enb), .clk(clk));
    register #(16) R4(.d(n_new), .q(n), .en(enn), .clk(clk));
    register #(16) R5(.d(i_new), .q(i), .en(eni), .clk(clk));
    register #(16) R6(.d(j_new), .q(j), .en(enj), .clk(clk));

    // Register output & intermediate calculations
    logic signed [31:0] aa, bb, twoab, distance;
    assign aa = a * a;
    assign bb = b * b;
    assign twoab = 32'd2 * a * b;
    assign distance = aa + bb;

    // ====== [ COMBINATIONAL NEXT VALUE LOGIC ] ======
    logic initx, inity, inita, initb, initn, initi, initj;

    // x += dx
    x_new = initx ? xmin : x + dx;

    // y += dy
    y_new = inity ? ymin : y + dy;

    // a = aa - bb + x
    a_new = inita ? x : aa - bb + x;

    // b = twoab + y
    b_new = initb ? y : twoab + y;

    // n++
    n_new = initn ? 16'd0 : n + 16'd1;

    // i++
    i_new = initi ? 16'd0 : i + 16'd1;

    // j++
    j_new = initj ? 16'd0 : j + 16'd1;

    // ====== [ BOOLEAN STATE MACHINE INPUT ] ======
    logic n_equals_iterations;
    logic donei, donej;
    logic dist_gt_max_dist;

    assign n_equals_iterations = n_new == iterations;   // FIXME: currently using new
    assign donei = i == 16'd319;
    assign donej = j == 16'd239;
    assign dist_gt_max_dist = distance > max_distance;

    // ====== [ STATE MACHINE ] ======

    // ====== [ VGA OUTPUT ] ======
    assign vga_x = i[8:0];
    assign vga_y = j[7:0];
    assign vga_colour = n[2:0];

endmodule