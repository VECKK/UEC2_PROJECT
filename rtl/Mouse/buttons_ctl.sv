/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Kacper Kierzek
 * Co-Author: Wiktoria Borycka
 *
 * Description: module to control mouse buttons and their actions in the game
 * 
 **/

module buttons_ctl (
    input  logic clk,
    input  logic rst,
    output logic first_click_done,
    output logic [11:0] xpos,
    output logic [11:0] ypos,
    output logic left,

    inout logic  ps2_clk,
    inout logic  ps2_data
);

timeunit 1ns;
timeprecision 1ps;

import vga_pkg::*;

logic left_latch, prev_left;
logic setx, sety;
logic [11:0] value_x, value_y;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        prev_left  <= 1'b0;
        left_latch <= 1'b0;
    end else begin
        prev_left  <= left;
        if (left && !prev_left)
            left_latch <= 1'b1;
        else
            left_latch <= 1'b0;
    end
end

always_ff @(posedge clk) begin
    if (rst)
        first_click_done <= 1'b0;
    else if (left_latch && !first_click_done)
        first_click_done <= 1'b1;
end

always_comb begin
    if (left && !first_click_done) begin
        setx = 1'b1;
        sety = 1'b1;
        value_x = START_X + (WIDTH / 2);
        value_y = START_Y + (HEIGHT / 2);
    end else begin
        setx = 1'b0;
        sety = 1'b0;
        value_x = 12'd0;
        value_y = 12'd0;
    end
end

MouseCtl u_mousectl (
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    .ypos(ypos),
    .zpos(),
    .left(left),
    .middle(),
    .right(),
    .value_x(value_x),
    .value_y(value_y),
    .setx(setx),
    .sety(sety),
    .setmax_x('d0),
    .setmax_y('d0),
    .new_event()
);

endmodule