module delay (
        input logic clk,
        input logic rst,
        output logic clk_delay
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic [18:0] counter;
    logic [18:0] counter_nxt;
    logic clk_delay_nxt;

    localparam TOGGLE_COUNT = 200_000;

    always_comb begin : clk_delay_comb_blk
        if (counter >= TOGGLE_COUNT) begin
            clk_delay_nxt = ~clk_delay;
            counter_nxt = '0;
        end else begin
            clk_delay_nxt = clk_delay;
            counter_nxt = counter + 1;
        end
    end

    always_ff @(posedge clk or posedge rst) begin : clk_delay_ff_blk
        if (rst) begin
            clk_delay <= 0;
            counter <= 0;
        end else begin
            clk_delay <= clk_delay_nxt;
            counter <= counter_nxt;
        end
    end


endmodule
