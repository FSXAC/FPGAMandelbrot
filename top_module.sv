module top_module(
    input logic CLOCK_50,
    input logic KEY[3:0],
    input logic [9:0] SW,

    output logic [9:0] VGA_R,
    output logic [9:0] VGA_G,
    output logic [9:0] VGA_B,
    output logic VGA_HS,
    output logic VGA_VS,
    output logic VGA_BLANK,
    output logic VGA_SYNC,
    output logic VGA_CLK
);

    // Instantiate and connectt VGA adapter
    logic reset, plot, plot_c, plot_fs;
    logic done_fs, done_mb;
    logic start_fs, start_mb;
    logic [2:0] color, colof_fs, color_mb;
    logic [7:0] x, x_fs, x_mb;
    logic [6:0] y, y_fs, y_mb;

    // Reset
    assign reset = KEY[3];

    vga_adapter #(.RESOLUTION("320x240")) VA(
        .resetn(reset),
        .clock(CLOCK_50),
        .colour(color),
        .x(x),
        .y(y),
        .plot(plot),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK(VGA_BLANK),
        .VGA_SYNC(VGA_SYNC),
        .VGA_CLK(VGA_CLK)
    );

    // Fillscreen module
    fillscreen FS(
        .clk(CLOCK_50),
        .rstn(reset),
        .colour(3'b0),
        .start(start_fs),

        .done(done_fs),
        .vga_x(x_fs),
        .vga_y(y_fs),
        .vga_colour(color_fs),
        .vga_plot(plot_fs)
    );

    // Mandelbrot module
    vga_out_controller(
        .plot_fs(plot_fs),
        .plot_shape(plot_c),
        .x_fs(x_fs),
        .x_shape(x_c),
        .y_fs(y_fs),
        .y_shape(y_c),
        .color_fs(color_fs),
        .color_shape(color_c),
        .start_shape(start_c),
        .plot(plot),
        .x(x),
        .y(y),
        .color(color)
    );

    // Draw controller
    draw_controller DC(
        .reset(reset),
        .clock(CLOCK_50),
        .done_fs(done_fs),
        .done_shape(done_mb),
        .start_fs(start_fs),
        .start_shape(start_mb)
    );
endmodule

// Module for controlling VGA output
module vga_out_controller(
    input logic plot_fs,
    input logic plot_shape,
    input logic [7:0] x_fs,
    input logic [7:0] x_shape,
    input logic [6:0] y_fs,
    input logic [6:0] y_shape,
    input logic [2:0] color_fs,
    input logic [2:0] color_shape,
    input logic start_shape,
    output logic plot,
    output logic [7:0] x,
    output logic [6:0] y,
    output logic [2:0] color
);
    assign plot = start_shape ? plot_shape : plot_fs;
    assign x = start_shape ? x_shape : x_fs;
    assign y = start_shape ? y_shape : y_fs;
    assign color = start_shape ? color_shape : color_fs;
endmodule

// Draw controller (controls start signals)
module draw_controller(
    input logic reset,
    input logic clock,
    input logic done_fs,
    input logic done_shape,
    output logic start_fs,
    output logic start_shape
);
    enum {FILL, DRAW, DONE} current, next;

    always_comb begin
        case (current)
            FILL: next = done_fs ? DRAW : FILL;
            DRAW: next = done_shape ? DONE : DRAW;
            DONE: next = DONE;
        endcase
    end

    always_ff @(posedge clock, negedge reset) begin
        current <= reset == 0 ? FILL : next;
    end

    always_comb begin
        start_fs = current == FILL;
        start_shape = current == DRAW;
    end
endmodule