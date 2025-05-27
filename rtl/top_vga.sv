/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2025  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

module top_vga (
        input  logic clk65MHz,
        input  logic rst,
        output logic vs,
        output logic hs,
        output logic [3:0] r,
        output logic [3:0] g,
        output logic [3:0] b,

        inout logic  ps2_clk,
        inout logic  ps2_data
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic [11:0] xpos;
    logic [11:0] ypos;
    logic [11:0] rgb_pixel;
    logic [11:0] pixel_addr;
    logic left;
    logic clk_delay;
    logic [11:0] xpos_ctl;
    logic [11:0] ypos_ctl;
    logic [7:0] char_line_pixels;
    logic [10:0] address;
    logic [7:0] char_xy;
    logic [6:0] char_code;
    logic [3:0] char_line;

    tbg_if timing_if();
    vga_if draw_bg_if();
    vga_if draw_rect_if();
    vga_if draw_mouse_if();
    vga_if draw_char_if();


    /**
     * Signals assignments
     */

    assign vs = draw_mouse_if.vsync;
    assign hs = draw_mouse_if.hsync;
    assign {r,g,b} = draw_mouse_if.rgb[11:0];


    /**
     * Submodules instances
     */

    vga_timing u_vga_timing (
        .clk65MHz(clk65MHz),
        .rst,
        .tout(timing_if)
    );

    draw_bg u_draw_bg (
        .clk65MHz(clk65MHz),
        .rst,

        .bgin(timing_if),
        .out(draw_bg_if)

    );

    draw_rect u_draw_rect (
        .clk65MHz(clk65MHz),
        .rst,

        .in (draw_char_if),
        .out(draw_rect_if),

        .xpos(xpos_ctl),
        .ypos(ypos_ctl),

        .rgb_pixel,
        .pixel_addr

    );

    draw_rect_char u_draw_rect_char (
        .clk(clk65MHz),
        .rst,
        .in(draw_bg_if),
        .out(draw_char_if),

        .char_line_pixels(char_line_pixels),
        .char_xy(char_xy),
        .char_line(char_line)
    );
    
    char_rom u_char_rom (
        .clk(clk65MHz),
        .rst,
        .char_xy(char_xy),
        .char_code(char_code)
    );

    always_comb begin
        address = {char_code, char_line};
    end

    font_rom u_font_rom (
        .clk(clk65MHz),
        .char_line_pixels(char_line_pixels),
        .addr(address)
    );


    image_rom u_image_rom (
        .clk(clk65MHz),

        .rgb(rgb_pixel),
        .address(pixel_addr)

    );

    draw_mouse u_draw_mouse (
        .clk65MHz(clk65MHz),
        .rst,

        .in(draw_rect_if),
        .out(draw_mouse_if),

        .xpos(xpos),
        .ypos(ypos)

    );

    MouseCtl u_mousectl (
        .clk(clk65MHz),
        .rst,
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .xpos(xpos),
        .ypos(ypos),

        .zpos(),
        .left(left),
        .middle(),
        .right(),
        .value(12'd0),
        .setx('b0),
        .sety('b0),
        .setmax_x('d0),
        .setmax_y('d0),
        .new_event()
    );

    draw_rect_ctl u_draw_rect_ctl (
        .clk(clk_delay),
        .rst,
        .mouse_left(left),
        .mouse_xpos(xpos),
        .mouse_ypos(ypos),
        .xpos(xpos_ctl),
        .ypos(ypos_ctl)
    );

    delay u_delay (
        .clk(clk65MHz),
        .rst,
        .clk_delay(clk_delay)
    );

endmodule
