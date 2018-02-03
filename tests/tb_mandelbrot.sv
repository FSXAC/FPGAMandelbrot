`define HIGH_RES

module tb_mandelbrot();
    reg clk, rst, start;
    reg done;

    `ifdef HIGH_RES
    reg [8:0] vga_x;
    reg [7:0] vga_y;
    `else
    reg [7:0] vga_x;
    reg [6:0] vga_y;
    `endif
    reg [2:0] vga_colour;
    reg vga_plot;

    mandelbrot MB(
        .clk(clk),
        .rstn(rst),
        .start(start),
        .done(done),
        .vga_x(vga_x),
        .vga_y(vga_y),
        .vga_colour(vga_colour),
        .vga_plot(vga_plot)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        start = 1'b0;

        #1 rst = 1'b1;
        #1 start = 1'b1;

        if (done == 1) begin
            #20;
            $stop;
        end
    end
endmodule