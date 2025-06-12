/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Kacper Kierzek
 * Co-Author: Wiktoria Borycka
 *
 * Description: module to draw player lifes on the screen
 * 
 **/


module draw_lifes(
    input  logic clk65MHz,
    input  logic rst,
    input  logic enable,
    input  logic lost_life,
    input  logic [11:0] lifes_rgb,
    output logic [10:0] lifes_addr,
    output logic endgame,

    vga_if.in in,
    vga_if.out out
);

timeunit 1ns;
timeprecision 1ps;

import vga_pkg::*;



logic [11:0] rgb_nxt;
logic [10:0] one_vcount;
logic [10:0] one_hcount;
logic [11:0] one_rgb;
logic        one_vsync, one_vblnk, one_hsync, one_hblnk;
logic [10:0] two_vcount;
logic [10:0] two_hcount;
logic [11:0] two_rgb;
logic        two_vsync, two_vblnk, two_hsync, two_hblnk;

logic [1:0] i;
logic [11:0] x_pos, y_pos;
logic [1:0] lifes_count;
logic lost_life_d, lost_life_edge;

localparam LIFE_W = 40;
localparam LIFE_H = 40;
localparam life_x = 12'd10; 
localparam life_y = 12'd718;
localparam SPACE = 5;

    always_ff @(posedge clk65MHz or posedge rst) begin
        if (rst) begin
            lost_life_d <= 1'b0;
        end else begin
            lost_life_d <= lost_life;
        end
    end

    assign lost_life_edge = lost_life && !lost_life_d; 

   
    always_ff @(posedge clk65MHz or posedge rst) begin
        if (rst) begin
            lifes_count <= 3; 
        end else if (lost_life_edge && lifes_count > 0) begin
            lifes_count <= lifes_count - 1; 
        end
    end

    always_comb begin
        endgame = (lifes_count == 0); 
    end

    always_ff @(posedge clk65MHz) begin : one_ff_blk
        if (rst) begin
            one_vcount <= '0;
            one_vsync  <= '0;
            one_vblnk  <= '0;
            one_hcount <= '0;
            one_hsync  <= '0;
            one_hblnk  <= '0;
            one_rgb    <= '0;
        end else begin
            one_vcount <= in.vcount;
            one_vsync  <= in.vsync;
            one_vblnk  <= in.vblnk;
            one_hcount <= in.hcount;
            one_hsync  <= in.hsync;
            one_hblnk  <= in.hblnk;
            one_rgb    <= in.rgb;
        end
    end

    always_ff @(posedge clk65MHz) begin : two_ff_blk
        if (rst) begin
            two_vcount <= '0;
            two_vsync  <= '0;
            two_vblnk  <= '0;
            two_hcount <= '0;
            two_hsync  <= '0;
            two_hblnk  <= '0;
            two_rgb    <= '0;        
        end else begin
            two_vcount <= one_vcount;
            two_vsync  <= one_vsync;
            two_vblnk  <= one_vblnk;
            two_hcount <= one_hcount;
            two_hsync  <= one_hsync;
            two_hblnk  <= one_hblnk;
            two_rgb    <= one_rgb;
        end
    end

    always_ff @(posedge clk65MHz) begin : spaceship_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
        end else begin
            out.vcount <= two_vcount;
            out.vsync  <= two_vsync;
            out.vblnk  <= two_vblnk;
            out.hcount <= two_hcount;
            out.hsync  <= two_hsync;
            out.hblnk  <= two_hblnk;
            out.rgb    <= rgb_nxt;
        end
    end

    always_comb begin
        rgb_nxt = in.rgb;
        lifes_addr = 0;

        if (!in.vblnk && !in.hblnk && enable) begin
            for (i = 0; i < 3; i++) begin
                if (i < lifes_count) begin
                
                    x_pos = life_x + i * (LIFE_W + SPACE); 
                    y_pos = life_y;

                    if (in.hcount >= x_pos && in.hcount < x_pos + LIFE_W &&
                        in.vcount >= y_pos && in.vcount < y_pos + LIFE_H) begin

                        lifes_addr = (in.vcount - y_pos) * LIFE_W + (in.hcount - x_pos);

                        if (lifes_rgb == 12'hE3F) begin
                            rgb_nxt = two_rgb; 
                        end else begin
                            rgb_nxt = lifes_rgb; 
                        end
                    end
                end
            end
        end
    end

endmodule