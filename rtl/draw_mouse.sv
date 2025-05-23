module draw_mouse (
        input  logic clk40MHz,
        input  logic rst,
        input  logic [11:0] xpos,
        input  logic [11:0] ypos,

        vga_if.in in,

        vga_if.out out
    );

    timeunit 1ns;
    timeprecision 1ps;

    /**
     * Internal logic
     */

    MouseDisplay u_mouse_display (
        .pixel_clk(clk40MHz),
        .xpos(xpos),
        .ypos(ypos),
        .vcount(in.vcount),
        .hcount(in.hcount),
        .blank(in.hblnk | in.vblnk),
        .rgb_in(in.rgb),
        .rgb_out(out.rgb),
        .enable_mouse_display_out()
    );

    always_ff @(posedge clk40MHz) begin : draw_mouse_ff_blk
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
