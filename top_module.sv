`define HIGH_RES

module top_module(
    input logic CLOCK_50,
    input logic KEY[3:0],
    input logic [9:0] SW,

    output logic [9:0] LEDR,
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
    logic reset, plot;
    logic done;
    logic start;
    logic [2:0] color;

    `ifdef HIGH_RES
    logic [8:0] x;
    logic [7:0] y;
    `else
    logic [7:0] x;
    logic [6:0] y;
    `endif

    // Reset
    assign reset = KEY[3];
    assign start = 1'b1;

    `ifdef HIGH_RES
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
    `else
    vga_adapter #(.RESOLUTION("160x120")) VA(
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
    `endif

    // Mandelbrot module
    mandelbrot MB(
        .clk(CLOCK_50),
        .rstn(reset),
        .start(start),
        .done(done),

        .zoom_level(SW[2:0]),
        .h_offset_level(SW[5:3]),
        .v_offset_level(SW[8:6]),

        .vga_x(x),
        .vga_y(y),
        .vga_colour(color),
        .vga_plot(plot)
    );
    
    // Debug lights
    `ifdef HIGH_RES
    assign LEDR[7:0] = y;
    `else
    assign LEDR[6:0] = y;
    `endif
    assign LEDR[8] = plot;
    assign LEDR[9] = done;
endmodule