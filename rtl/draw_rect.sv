module draw_rect (
        input  logic clk65MHz,
        input  logic rst,
        input  logic [11:0] xpos,
        input  logic [11:0] ypos,
        input  logic [11:0] rgb_pixel,
        output logic [11:0] pixel_addr,

        vga_if.in in,

        vga_if.out out
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    localparam WIDTH = 48;
    localparam HEIGHT = 64;
    //localparam RGB_RECT = 12'hF00;

    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;
    logic [10:0] one_vcount;
    logic [10:0] one_hcount;
    logic [11:0] one_rgb;
    logic        one_vsync;
    logic        one_vblnk;
    logic        one_hsync;
    logic        one_hblnk;
    logic [10:0] two_vcount;
    logic [10:0] two_hcount;
    logic [11:0] two_rgb;
    logic        two_vsync;
    logic        two_vblnk;
    logic        two_hsync;
    logic        two_hblnk;


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

    always_ff @(posedge clk65MHz) begin : rect_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
            pixel_addr <= '0;
        end else begin
            out.vcount <= two_vcount;
            out.vsync  <= two_vsync;
            out.vblnk  <= two_vblnk;
            out.hcount <= two_hcount;
            out.hsync  <= two_hsync;
            out.hblnk  <= two_hblnk;
            out.rgb    <= rgb_nxt;
            pixel_addr <= {6'(in.vcount - ypos), 6'(in.hcount - xpos)};
        end
    end

    always_comb begin : rect_comb_blk
        rgb_nxt = two_rgb;

        if (two_hcount >= xpos && two_hcount < xpos + WIDTH &&
            two_vcount >= ypos && two_vcount < ypos + HEIGHT) begin
            rgb_nxt = rgb_pixel;
        end
    end

endmodule
