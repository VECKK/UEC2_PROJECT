module game_reset (
    input  logic clk,
    input  logic rst,
    input  logic endgame,
    input  logic left,
    output logic reset_game
);

    logic prev_left;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_left   <= 1'b0;
            reset_game  <= 1'b0;
        end else begin
            prev_left <= left;
            if (endgame && left && !prev_left)
                reset_game <= 1'b1;
            else
                reset_game <= 1'b0;
        end
    end

endmodule