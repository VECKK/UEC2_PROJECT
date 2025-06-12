/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: Not used for now, made for future use in game reset logic
 * 
 **/

module game_reset (
    input  logic clk,
    input  logic rst,
    input  logic endgame,
    input  logic right,
    output logic reset_game
);

    logic prev_right;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_right   <= 1'b0;
            reset_game  <= 1'b0;
        end else begin
            prev_right <= right;
            if (endgame && right && !prev_right)
                reset_game <= 1'b1;
            else
                reset_game <= 1'b0;
        end
    end

endmodule