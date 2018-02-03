module statemachine (
    // Logisitc input
    input logic clk,
    input logic rst,
    input logic start,

    // conditions
    input logic n_equals_iterations,
    input logic donei,
    input logic donej,
    input logic dist_gt_max_dist,

    // output
    output logic enx,
    output logic eny,
    output logic ena,
    output logic enb,
    output logic enn,
    output logic eni,
    output logic enj,

    output logic initx,
    output logic inity,
    output logic inita,
    output logic initb,
    output logic initn,
    output logic initi,
    output logic initj,

    // Logistic output
    output logic plot,
    output logic done
);
    // States
    enum {
        IDLE,
        INIT,
        JLOOP,
        ILOOP,
        ITERLOOP,
        PLOT,
        ENDLOOP,
        DONE
    } current, next;

    // Next state logic
    always_comb begin
        case (current)
            IDLE: next = start ? INIT : IDLE;
            INIT: next = JLOOP;
            JLOOP: next = ILOOP;
            ILOOP: next = ITERLOOP;
            ITERLOOP: next = dist_gt_max_dist ? PLOT : ITERLOOP;
            PLOT: next = donei ? ENDLOOP : ILOOP;
            ENDLOOP: next = donej ? DONE : JLOOP;
            DONE: next = DONE;
        endcase
    end

    // Non blocking sequential logic
    always_ff @(posedge clk, negedge rst) begin
        current <= rst == 0 ? IDLE : next;
    end

    // Combinational output logic
    always_comb begin
        // Set all output to low by default
        {enx, eny, ena, enb, enn, eni, enj} = 7'b0;
        {initx, inity, inita, initb, initn, initi, initj} = 7'b0;
        {plot, done} = 2'b0;

        // Turn selective signals on based on state
        case (current)
            INIT: begin
                {inity, initi, initj} = 3'b111;
                {eny, eni, enj} = 3'b111;
            end
            JLOOP: {initx, enx} = 2'b11;
            ILOOP: begin
                {inita, initb, initn} = 3'b111;
                {ena, enb, enn} = 3'b111;
            end
            ITERLOOP: {ena, enb, enn} = 3'b111;
            PLOT: {enx, plot} = 2'b11;
            ENDLOOP: eny = 1'b1;
            DONE: done = 1'b1;
            default: done = 1'b0;
        endcase
    end
endmodule