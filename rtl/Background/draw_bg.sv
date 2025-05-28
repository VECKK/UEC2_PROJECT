module draw_bg (
    input  logic clk65MHz,
    input  logic rst,
    input  logic [11:0] rom_rgb,
    output logic [13:0] rom_addr,

    tbg_if.bgin bgin,
    vga_if.out out
);

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    localparam IMG_WIDTH = 128;
    localparam IMG_HEIGHT = 96;

    logic [11:0] rgb_nxt;
    logic [10:0] one_vcount;
    logic [10:0] one_hcount;
    logic        one_vsync, one_vblnk, one_hsync, one_hblnk;
    logic [10:0] two_vcount;
    logic [10:0] two_hcount;
    logic        two_vsync, two_vblnk, two_hsync, two_hblnk;

    /**
     * Stage 1 - pipeline
     */
    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            one_vcount <= '0;
            one_vsync  <= '0;
            one_vblnk  <= '0;
            one_hcount <= '0;
            one_hsync  <= '0;
            one_hblnk  <= '0;
        end else begin
            one_vcount <= bgin.vcount;
            one_vsync  <= bgin.vsync;
            one_vblnk  <= bgin.vblnk;
            one_hcount <= bgin.hcount;
            one_hsync  <= bgin.hsync;
            one_hblnk  <= bgin.hblnk;
        end
    end

    /**
     * Stage 2 - pipeline
     */
    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            two_vcount <= '0;
            two_vsync  <= '0;
            two_vblnk  <= '0;
            two_hcount <= '0;
            two_hsync  <= '0;
            two_hblnk  <= '0;
        end else begin
            two_vcount <= one_vcount;
            two_vsync  <= one_vsync;
            two_vblnk  <= one_vblnk;
            two_hcount <= one_hcount;
            two_hsync  <= one_hsync;
            two_hblnk  <= one_hblnk;
        end
    end

    always_ff @(posedge clk65MHz) begin
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

    /**
     * Logic: select background color from ROM
     */
    always_comb begin
        if (two_vblnk || two_hblnk)
            rgb_nxt = 12'h000;
        else
            rgb_nxt = rom_rgb;
    end

    /**
     * Compute ROM address (row-major order)
     */
    always_comb begin
        if (two_hcount < HOR_PIXELS && two_vcount < VER_PIXELS) begin
            automatic int img_x = (two_hcount * IMG_WIDTH) / HOR_PIXELS;
            automatic int img_y = (two_vcount * IMG_HEIGHT) / VER_PIXELS;
            rom_addr = img_y * IMG_WIDTH + img_x;
        end else begin
            rom_addr = 0;
        end
    end

endmodule