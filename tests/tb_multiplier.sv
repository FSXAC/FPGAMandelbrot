module tb_multiplier();
    reg signed [31:0] a, b, out;
    reg [9:0] i;
    reg [21:0] f;

    assign i = out[31:22];
    assign f = out[21:0];

    multiplier DUT(
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
        // 0.5 * 0.625 = 0.3125
        a = {10'b0, 1'b1, 21'b0};
        b = {10'b0, 3'b101, 19'b0};
        #5;

        // 1.75 * 0.015625 = 0.02734375
        a = {10'b1, 2'b11, 20'b0};
        b = {10'b0, 6'b000001, 16'b0};
        #5;

        // -1.5 * 1.5 = -2.25
        a = {9'b111111111, 1'b0, 1'b1, 21'b0};
        b = {10'b1, 1'b1, 21'b0};
        #5;

        // 2.0 * -6.0 = -12.0
        a = {10'b10, 22'b0};
        b = {7'b1111111, 3'b010, 22'b0};
        #5;

        // -0.5 * -3.0 = 1.5
        a = {10'b1111111111, 1'b1, 21'b0};
        b = {8'b11111111, 2'b01, 22'b0};
        #5;

        $stop;
    end
endmodule