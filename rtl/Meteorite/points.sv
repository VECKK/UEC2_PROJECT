module points (
    input logic clk,
    input logic rst,
    input logic endgame,
    input logic [1:0] points,
    input logic [1:0] points_v2,
    input logic [1:0] points_medium,
    input logic [1:0] points_medium_v2,
    input logic [1:0] points_medium_v3,
    input logic [1:0] points_medium_v4,
    input logic [1:0] points_small,
    input logic [1:0] points_small_v2,
    input logic [1:0] points_small_v3,
    input logic [1:0] points_small_v4,
    input logic [1:0] points_small_v5,
    input logic [1:0] points_small_v6,
    input logic [1:0] points_small_v7,
    input logic [1:0] points_small_v8,
    output logic [5:0] total_points
);

logic [5:0] total_points_reg;

always_ff @(posedge clk) begin
    if (rst) begin
        total_points_reg <= 6'd0;
    end else if (!endgame) begin
        total_points_reg <= points + points_v2 + points_medium + points_medium_v2 + points_medium_v3 + points_medium_v4
                          + points_small + points_small_v2 + points_small_v3 + points_small_v4
                          + points_small_v5 + points_small_v6 + points_small_v7 + points_small_v8;
    end
    // Gdy endgame==1, rejestr nie jest już aktualizowany
end

assign total_points = total_points_reg;

endmodule