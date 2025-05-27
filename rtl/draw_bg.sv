/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */

module draw_bg (
        input  logic clk65MHz,
        input  logic rst,

        tbg_if.bgin bgin,

        vga_if.out out

    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;


    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;


    /**
     * Internal logic
     */

    always_ff @(posedge clk65MHz) begin : bg_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
        end else begin
            out.vcount <= bgin.vcount;
            out.vsync  <= bgin.vsync;
            out.vblnk  <= bgin.vblnk;
            out.hcount <= bgin.hcount;
            out.hsync  <= bgin.hsync;
            out.hblnk  <= bgin.hblnk;
            out.rgb    <= rgb_nxt;
        end
    end

    always_comb begin : bg_comb_blk
        if (bgin.vblnk || bgin.hblnk) begin             // Blanking region:
            rgb_nxt = 12'h0_0_0;                    // - make it it black.
        end else begin                              // Active region:
            if (bgin.vcount == 0)                     // - top edge:
                rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
            else if (bgin.vcount == VER_PIXELS - 1)   // - bottom edge:
                rgb_nxt = 12'hf_0_0;                // - - make a red line.
            else if (bgin.hcount == 0)                // - left edge:
                rgb_nxt = 12'h0_f_0;                // - - make a green line.
            else if (bgin.hcount == HOR_PIXELS - 1)   // - right edge:
                rgb_nxt = 12'h0_0_f;                // - - make a blue line.

            else if (
                //"W"
                (bgin.hcount >= (HOR_PIXELS/2 - 60) && bgin.hcount <= (HOR_PIXELS/2 - 55) && bgin.vcount >= (VER_PIXELS/2 - 40) && bgin.vcount <= (VER_PIXELS/2 + 40)) || 
                (bgin.vcount >= (-1 * bgin.hcount + 680) && bgin.vcount <= (-1 * bgin.hcount + 685) && bgin.vcount >= (VER_PIXELS/2 + 15 ) && bgin.vcount <= (VER_PIXELS/2 + 40)) || 
                (bgin.vcount >= (bgin.hcount - 55) && bgin.vcount <= (bgin.hcount - 50) && bgin.vcount >= (VER_PIXELS/2 + 15 ) && bgin.vcount <= (VER_PIXELS/2 + 40)) || 
                (bgin.hcount >= (HOR_PIXELS/2 - 10) && bgin.hcount <= (HOR_PIXELS/2 - 5) && bgin.vcount >= (VER_PIXELS/2 - 40) && bgin.vcount <= (VER_PIXELS/2 + 40)) ||
        
                //"B"
                (bgin.hcount >= (HOR_PIXELS/2 + 10)  && bgin.hcount <= (HOR_PIXELS/2 + 15) && bgin.vcount >= (VER_PIXELS/2 - 40) && bgin.vcount <= (VER_PIXELS/2 + 40)) ||
                (bgin.hcount >= (HOR_PIXELS/2 + 10)  && bgin.hcount <= (HOR_PIXELS/2 + 45) && bgin.vcount >= (VER_PIXELS/2 - 40) && bgin.vcount <= (VER_PIXELS/2 -35)) ||
                (bgin.hcount >= (HOR_PIXELS/2 + 10)  && bgin.hcount <= (HOR_PIXELS/2 + 45) && bgin.vcount >= (VER_PIXELS/2 - 5) && bgin.vcount <= (VER_PIXELS/2)) ||
                (bgin.hcount >= (HOR_PIXELS/2 + 10)  && bgin.hcount <= (HOR_PIXELS/2 + 45) && bgin.vcount >= (VER_PIXELS/2 + 35) && bgin.vcount <= (VER_PIXELS/2 + 40)) ||
                (bgin.vcount >= (bgin.hcount - 185) && bgin.vcount <= (bgin.hcount - 180) && bgin.vcount >= (VER_PIXELS/2 -40 ) && bgin.vcount <= (VER_PIXELS/2 -35)) ||
                (bgin.vcount >= (-1 * bgin.hcount + 740) && bgin.vcount <= (-1 * bgin.hcount + 745) && bgin.vcount >= (VER_PIXELS/2 - 5) && bgin.vcount <= (VER_PIXELS/2)) ||
                (bgin.vcount >= (bgin.hcount - 151) && bgin.vcount <= (bgin.hcount - 146) && bgin.vcount >= (VER_PIXELS/2 - 5) && bgin.vcount <= (VER_PIXELS/2)) ||
                (bgin.vcount >= (-1 * bgin.hcount + 781) && bgin.vcount <= (-1 * bgin.hcount + 786) && bgin.vcount >= (VER_PIXELS/2 + 35) && bgin.vcount <= (VER_PIXELS/2 + 40)) ||
                (bgin.hcount >= (HOR_PIXELS/2 + 45)  && bgin.hcount <= (HOR_PIXELS/2 + 50) && bgin.vcount >= (VER_PIXELS/2 - 35) && bgin.vcount <= (VER_PIXELS/2 - 5)) ||
                (bgin.hcount >= (HOR_PIXELS/2 + 46)  && bgin.hcount <= (HOR_PIXELS/2 + 51) && bgin.vcount >= (VER_PIXELS/2) && bgin.vcount <= (VER_PIXELS/2 + 35))
            )
                rgb_nxt = 12'hF_0_F; 
        
            else
               rgb_nxt = 12'h8_8_8;  // - fill with gray.
        end
    end

endmodule
