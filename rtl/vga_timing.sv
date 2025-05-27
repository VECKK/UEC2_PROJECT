/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Vga timing controller.
 */

module vga_timing (
        input  logic clk65MHz,
        input  logic rst,

        tbg_if.tout tout
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    logic [10:0] vcount_nxt, hcount_nxt;
    logic vsync_nxt, vblnk_nxt, hsync_nxt, hblnk_nxt;

    always_ff @(posedge clk65MHz or posedge rst) begin
        if (rst) begin
            tout.vcount <= 0;
            tout.hcount <= 0;
            tout.vsync <= 0;
            tout.vblnk <= 0;
            tout.hsync <= 0;
            tout.hblnk <= 0;
        end else begin
            tout.vcount <= vcount_nxt;
            tout.hcount <= hcount_nxt;
            tout.vsync <= vsync_nxt;
            tout.vblnk <= vblnk_nxt;
            tout.hsync <= hsync_nxt;
            tout.hblnk <= hblnk_nxt;
        end
    end

    always_comb begin
        
        vcount_nxt = tout.vcount;
        hcount_nxt = tout.hcount + 1;
        vsync_nxt = tout.vsync;
        vblnk_nxt = tout.vblnk;
        hblnk_nxt = tout.hblnk;


        if ((tout.vcount == VER_TOTAL_TIME - 1) && (tout.hcount == HOR_TOTAL_TIME - 1)) begin 
            vcount_nxt = 0; 
            vblnk_nxt = 0; 
        end else if (tout.hcount == HOR_TOTAL_TIME - 1) begin
            vcount_nxt = tout.vcount + 1; 
        end 
        
        if ((tout.vcount == VER_BLANK_START - 1) && (tout.hcount == HOR_TOTAL_TIME - 1)) begin
            vblnk_nxt = 1;
        end

        if ((tout.vcount >= VER_SYNC_START - 1) && (tout.hcount == HOR_TOTAL_TIME - 1)) begin
            vsync_nxt = (tout.vcount < VER_SYNC_END - 1);
        end 

        if (tout.hcount == HOR_TOTAL_TIME - 1) begin
            hcount_nxt = 0;
            hblnk_nxt = 0;
        end else if (tout.hcount == HOR_BLANK_START - 1) begin
            hblnk_nxt = 1;
        end

            hsync_nxt = (tout.hcount >= HOR_SYNC_START - 1) && (tout.hcount < HOR_SYNC_END - 1);

    end

endmodule
