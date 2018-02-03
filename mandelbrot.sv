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
endmodule