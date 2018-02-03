module register(d, q, en, clk);
    parameter BITS = 32;
    input logic [BITS-1:0] d;
    input logic en, clk;
    output logic [BITS-1:0] q;

    always_ff @(posedge clk) begin
        q <= en ? d : q;
    end
endmodule