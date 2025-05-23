module draw_rect_char(
        input logic clk,
        input logic rst,
        vga_if.in in,
        vga_if.out out,
        input logic [7:0] char_line_pixels,
        output logic [7:0] char_xy,
        output logic [3:0] char_line
    );

    timeunit 1ns;
    timeprecision 1ps;

    vga_if lag();
    vga_if lag2();

    localparam POS_X = 50;
    localparam POS_Y = 50;
    localparam CHAR_H = 128;
    localparam CHAR_W = 256;

    logic [11:0] rgb_nxt;
    logic [10:0] x_offset;
    logic [10:0] y_offset;


    always_ff @(posedge clk) begin : lag_ff_blk
        if (rst) begin
            lag.vcount <= '0;
        end else begin
            lag.vcount <= in.vcount;
        end
    end

    delay_rgb #(
        .WIDTH(38),
        .CLK_DEL(2)) 
    u_delay_rgb (
        .clk(clk),
        .rst(rst),
        .din({in.vcount, in.vsync, in.vblnk, in.hcount, in.hsync, in.hblnk, in.rgb}),
        .dout({lag2.vcount, lag2.vsync, lag2.vblnk, lag2.hcount, lag2.hsync, lag2.hblnk, lag2.rgb})
    );

    always_ff @(posedge clk) begin : lag2_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
        end else begin
            out.vcount <= lag2.vcount;
            out.vsync  <= lag2.vsync;
            out.vblnk  <= lag2.vblnk;
            out.hcount <= lag2.hcount;
            out.hsync  <= lag2.hsync;
            out.hblnk  <= lag2.hblnk;
            out.rgb    <= rgb_nxt;
        end
    end

    always_comb begin : frame_xy_comb
        x_offset = in.hcount - POS_X;
        y_offset = in.vcount - POS_Y;
        char_xy = (y_offset[9:4] * 32) + x_offset[9:3];
        char_line = lag.vcount[3:0] - POS_Y[3:0];
    end

    always_comb begin : char_area_comb
        if ((lag2.hcount >= POS_X) && (lag2.hcount < (POS_X + CHAR_W)) &&
            (lag2.vcount >= POS_Y) && (lag2.vcount < (POS_Y + CHAR_H))) begin
            rgb_nxt = (char_line_pixels[7 - (lag2.hcount - POS_X) % 8] == 0) ? lag2.rgb : 12'h000;
        end else begin
            rgb_nxt = lag2.rgb;
        end
    end

endmodule