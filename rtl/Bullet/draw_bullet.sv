module draw_bullet (
        input  logic clk65MHz,
        input  logic rst,
        input  logic [11:0] rgb_bullet,
        input  logic [11:0] spaceship_x,
        input  logic [11:0] spaceship_y,
        input  logic        visible,
        output logic [7:0] bullet_addr,

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


    /**
     * Internal logic
     */

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

    always_comb begin : spaceship_comb_blk
        rgb_nxt = two_rgb;

        if (visible &&  
            two_hcount >= (spaceship_x + ((WIDTH / 2) - 2)) && two_hcount < (spaceship_x + ((WIDTH / 2) - 2)) + BULLET_W &&
            two_vcount >= (spaceship_y + 2) && two_vcount < (spaceship_y + 2) + BULLET_H) begin
            if (rgb_bullet == 12'hE3F) begin
                rgb_nxt = two_rgb; // Use input RGB if rgb_bullet matches E3F
            end else begin
                rgb_nxt = rgb_bullet;
            end
        end
    end

    always_comb begin
        if (visible &&
            two_hcount >= (spaceship_x + ((WIDTH / 2) - 2)) && two_hcount < (spaceship_x + ((WIDTH / 2) - 2)) + BULLET_W &&
            two_vcount >= (spaceship_y + 2) && two_vcount < (spaceship_y + 2) + BULLET_H
        ) begin
            bullet_addr = ((two_vcount - (spaceship_y + 2)) * BULLET_W) + (two_hcount - (spaceship_x + ((WIDTH / 2) - 2)));
        end else begin
            bullet_addr = 0;
        end
    end

endmodule