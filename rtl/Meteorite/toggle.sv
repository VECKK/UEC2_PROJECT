/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 *
 * Description: module to toggle a signal at a specific frequency
 * 
 **/


module toggle #(
    parameter TOGGLE_MAX = 32_500_000 - 1 
    )(
    input  logic clk,
    input  logic rst,
    output logic toggle
);
    logic [25:0] counter;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            toggle <= 1'b0;
        end else if (counter == TOGGLE_MAX) begin
            counter <= 0;
            toggle <= ~toggle;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule