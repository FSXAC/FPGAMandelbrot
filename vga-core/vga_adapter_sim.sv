// For simulation only

module vga_adapter(input logic resetn, input logic clock, input logic [2:0] colour,
                   input logic [7:0] x, input logic [6:0] y, input logic plot,
                   output logic [9:0] VGA_R, output logic [9:0] VGA_G, output logic [9:0] VGA_B,
                   output logic VGA_HS, output logic VGA_VS, output logic VGA_BLANK,
                   output logic VGA_SYNC, output logic VGA_CLK);
    parameter BITS_PER_COLOUR_CHANNEL = 1;
    parameter MONOCHROME = "FALSE";
    parameter RESOLUTION = "320x240";
    parameter BACKGROUND_IMAGE = "background.mif";
    parameter USING_DE1 = "FALSE";

    always_ff @(posedge clock, negedge resetn) begin
        if (~resetn) begin
            $display("VGA: reset");
        end else if (plot) begin
            $display("VGA: plot (%d,%d) colour %03b", x, y, colour);
        end
    end
endmodule: vga_adapter

