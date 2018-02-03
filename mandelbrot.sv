// FIXED POINT CONVENTION (32 bits)
// | 10 integer bits | 22 fraction bits |
`define INT(n) n[31:22]
`define FRAC(n) n[21:0]

`define HIGH_RES

`ifdef HIGH_RES
`define WIDTH 16'd320
`define HEIGHT 16'd240
`else
`define WIDTH 16'd160
`define HEIGHT 16'd120
`endif

module mandelbrot(
    input logic clk,
    input logic rstn,
    input logic start,
    output logic done,

    // Zoom and position control
    input logic [2:0] zoom_level,
    input logic [2:0] h_offset_level,
    input logic [2:0] v_offset_level,

    `ifdef HIGH_RES
    output logic [8:0] vga_x,
    output logic [7:0] vga_y,
    `else
    output logic [7:0] vga_x,
    output logic [6:0] vga_y,
    `endif

    output logic [2:0] vga_colour,
    output logic vga_plot
);

    // ======= [ COMB CONST & COMB CONST COMPUTATIONS ] =======
    logic signed [31:0] w, h, xmin, xmax, ymin, ymax, dx, dy;
    logic signed [31:0] h_offset, v_offset;

    // Computing the combination const values
    always_comb begin
        case (zoom_level)
            3'b000: w = {10'd10, 22'b0};        // 10
            3'b001: w = {10'd4, 22'b0};         // 4
            3'b010: w = {10'd2, 22'b0};         // 2
            3'b011: w = {10'd1, 22'b0};         // 1
            3'b100: w = {10'b0, 2'b11, 20'b0};  // 0.75
            3'b101: w = {10'b0, 1'b1, 21'b0};   // 0.5
            3'b110: w = {10'b0, 3'b011, 19'b0}; // 0.375
            3'b111: w = {10'b0, 2'b01, 20'b0};  // 0.25
        endcase
    end

    // h = w * 0.75
    multiplier M0(.a(w), .b({10'b0, 2'b11, 20'b0}), .out(h));

    // xmin = (w + offset) * -0.5 = (w + offset) / 2 * -1
    always_comb begin
        case (h_offset_level)
            3'b000: h_offset = {10'd3, 1'b1, 21'b0};           // 3.5
            3'b001: h_offset = {10'd2, 2'b11, 20'b0};          // 2.75
            3'b010: h_offset = {10'd2, 22'b0};                 // 2
            3'b011: h_offset = {10'd1, 1'b1, 22'b0};           // 1.5
            3'b100: h_offset = {10'd1, 22'b0};                 // 1
            3'b101: h_offset = {10'd0, 2'b01, 20'b0};          // 0.25
            3'b110: h_offset = {10'd0, 22'b0};                 // 0
            3'b111: h_offset = {10'b1111111111, 1'b1, 21'b0};  // -0.5
        endcase
    end
    assign xmin = ((w + h_offset) >> 1) * ~(32'b0);

    // xmax = xmin + w
    assign xmax = xmin + w;

    // ymin = (h + offset) * -0.5 = (h + offset) / 2 * -1
    always_comb begin
        case (v_offset_level)
            3'b000: v_offset = {10'd2, 22'b0};                  // 2
            3'b001: v_offset = {10'd1, 1'b1, 21'b0};            // 1.5
            3'b010: v_offset = {10'd1, 22'b0};                  // 1
            3'b011: v_offset = {10'd0, 1'b1, 22'b0};            // 0.5
            3'b100: v_offset = {10'd0, 22'b0};                  // 0
            3'b101: v_offset = {10'b1111111111, 1'b1, 21'b0};   // -0.5
            3'b110: v_offset = {10'b1111111111, 22'b0};         // -1
            3'b111: v_offset = {10'b1111111110, 1'b1, 21'b0};   // -1.5
        endcase
    end
    assign ymin = ((h + v_offset) >> 1) * ~(32'b0);

    // ymax = ymin + h
    assign ymax = ymin + h;

    // dx = 0.003125 * (xmax - xmin)
    multiplier M_DX(
        .a(xmax - xmin),

        `ifdef HIGH_RES
        .b({10'b0, 22'b0000000011001100110011}), // 1/320
        `else
        .b({10'b0, 22'b0000000110011001100110}),  // 1/160
        `endif

        .out(dx)
    );

    // dy = 0.0041666666... * (ymax - ymin)
    multiplier M_DY(
        .a(ymax - ymin),
        
        `ifdef HIGH_RES
        .b({10'b0, 22'b0000000100010001000100}), // 1/240
        `else
        .b({10'b0, 22'b0000001000100010001000}),  // 1/120
        `endif

        .out(dy)
    );

    // ====== [ CONSTS ] ======
    logic [15:0] iterations;
    assign iterations = 16'd32;

    logic signed [31:0] max_distance;
    assign max_distance = {10'd16, 22'b0};

    // ====== [ REGISTERS ] ======
    // Register connections
    logic enx, eny, ena, enb, enn, eni, enj;
    logic signed [31:0] x, y, a, b;
    logic signed [31:0] x_new, y_new, a_new, b_new;
    logic [15:0] n, i, j;
    logic [15:0] n_new, i_new, j_new;

    // Registers
    register REG_X(.d(x_new), .q(x), .en(enx), .clk(clk));
    register REG_Y(.d(y_new), .q(y), .en(eny), .clk(clk));
    register REG_A(.d(a_new), .q(a), .en(ena), .clk(clk));
    register REG_B(.d(b_new), .q(b), .en(enb), .clk(clk));
    register #(16) REG_N(.d(n_new), .q(n), .en(enn), .clk(clk));
    register #(16) REG_I(.d(i_new), .q(i), .en(eni), .clk(clk));
    register #(16) REG_J(.d(j_new), .q(j), .en(enj), .clk(clk));

    // ====== [ LOOP INTERMEDIATE CALC ] ======
    logic signed [31:0] aa, bb, ab, twoab, distance;
    
    // aa = a * a
    multiplier M_AA(.a(a), .b(a), .out(aa));

    // bb = b * b
    multiplier M_BB(.a(b), .b(b), .out(bb));

    // twoab = 2 * a * b = 2 * ab
    multiplier M_AB(.a(a), .b(b), .out(ab));
    assign twoab = 32'd2 * ab;

    // distance = aa + bb
    assign distance = aa + bb;

    // ====== [ COMBINATIONAL NEXT VALUE LOGIC ] ======
    logic initx, inity, inita, initb, initn, initi, initj;

    // x += dx
    assign x_new = initx ? xmin : x + dx;

    // y += dy
    assign y_new = inity ? ymin : y + dy;

    // a = aa - bb + x
    assign a_new = inita ? x : aa - bb + x;

    // b = twoab + y
    assign b_new = initb ? y : twoab + y;

    // n++
    assign n_new = initn ? 16'd0 : n + 16'd1;

    // i++
    assign i_new = initi ? 16'd0 : i + 16'd1;

    // j++
    assign j_new = initj ? 16'd0 : j + 16'd1;

    // ====== [ BOOLEAN STATE MACHINE INPUT ] ======
    logic n_equals_iterations;
    logic n_lt_iterations;
    logic donei, donej;
    logic dist_gt_max_dist;

    assign n_equals_iterations = n_new == iterations;
    assign n_lt_iterations = n_new < iterations;
    assign donei = i_new == `WIDTH;
    assign donej = j_new == `HEIGHT;
    assign dist_gt_max_dist = distance > max_distance;

    // ====== [ STATE MACHINE ] ======
    statemachine SM(
        .clk(clk),
        .rst(rstn),
        .start(start),

        .n_equals_iterations(n_equals_iterations),
        .n_lt_iterations(n_lt_iterations),
        .donei(donei),
        .donej(donej),
        .dist_gt_max_dist(dist_gt_max_dist),

        .enx(enx),
        .eny(eny),
        .ena(ena),
        .enb(enb),
        .enn(enn),
        .eni(eni),
        .enj(enj),

        .initx(initx),
        .inity(inity),
        .inita(inita),
        .initb(initb),
        .initn(initn),
        .initi(initi),
        .initj(initj),

        .plot(vga_plot),
        .done(done)
    );

    // ====== [ VGA OUTPUT ] ======
    `ifdef HIGH_RES
    assign vga_x = i[8:0];
    assign vga_y = j[7:0];
    `else
    assign vga_x = i[7:0];
    assign vga_y = j[6:0];
    `endif
    assign vga_colour = n_equals_iterations ? 3'b000 : n[2:0];

endmodule