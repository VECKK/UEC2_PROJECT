/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 *
 * Description: module to draw the mouse cursor on the screen
 * 
 **/


module draw_mouse (
        input  logic clk65MHz,
        input  logic rst,
        input  logic [11:0] xpos,
        input  logic [11:0] ypos,
        input  logic left_mouse,
        input  logic endgame,
        output logic show_cursor,

        vga_if.in in,
        vga_if.out out
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic cursor_visible = 1'b1; 

    always_ff @(posedge clk65MHz) begin
        if (rst)
            cursor_visible <= 1'b1; 
        else if (endgame)
            cursor_visible <= 1'b1;
        else if (left_mouse)
            cursor_visible <= 1'b0; 
    end

    assign show_cursor = cursor_visible;

    MouseDisplay u_mouse_display (
        .pixel_clk(clk65MHz),
        .xpos(xpos),
        .ypos(ypos),
        .vcount(in.vcount),
        .hcount(in.hcount),
        .blank(in.hblnk | in.vblnk),
        .rgb_in(in.rgb),
        .rgb_out(out.rgb),
        .enable_mouse_display_out(),
        .show_cursor(show_cursor)
    );

    always_ff @(posedge clk65MHz) begin : draw_mouse_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
        end else begin
            out.vcount <= in.vcount;
            out.vsync  <= in.vsync;
            out.vblnk  <= in.vblnk;
            out.hcount <= in.hcount;
            out.hsync  <= in.hsync;
            out.hblnk  <= in.hblnk;
        end
    end

endmodule
