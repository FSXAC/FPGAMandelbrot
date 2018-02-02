module vga_demo(input logic CLOCK_50, input logic KEY[3:0], input logic [17:0] SW,
                output logic [9:0] VGA_R, output logic [9:0] VGA_G, output logic [9:0] VGA_B,
                output logic VGA_HS, output logic VGA_VS,
                output logic VGA_BLANK, output logic VGA_SYNC, output logic VGA_CLK);
    vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(SW[17:15]),
                                                .x(SW[7:0]), .y(SW[14:8]), .plot(~KEY[0]), .*);
endmodule: vga_demo

