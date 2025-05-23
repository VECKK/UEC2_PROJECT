module char_rom(
        input logic clk,
        input logic rst,
        input logic [7:0] char_xy,
        output logic [6:0] char_code
    );

    timeunit 1ns;
    timeprecision 1ps;

    localparam string TEXT = "Happiness grows when we share our time, kindness, and dreams with others. Every moment we choose hope over fear and love over hate, we plant seeds of a better future that blossom in ways we may not see but can always believe in.";

    logic [7:0] char_table [0:255];

    initial begin
        for (int i = 0; i < 256; i++) begin
            char_table[i] = 8'h20;
        end

        for (int i = 0; i < TEXT.len(); i++) begin
            char_table[i] = TEXT[i];
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            char_code <= 7'h20;
        end else begin
            char_code <= char_table[char_xy][6:0];
        end
    end

endmodule