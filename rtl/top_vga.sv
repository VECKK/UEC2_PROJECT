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

    import vga_pkg::*;

    logic [11:0] xpos;
    logic [11:0] ypos;
    //spaceship
    logic [11:0] rgb_pixel;
    logic [12:0] pixel_addr;
    logic left;
    logic [11:0] spaceship_x;
    logic [11:0] spaceship_y;
    logic active_schoot;

    logic clk_delay;
    logic [7:0] char_line_pixels;
    logic [10:0] address;
    logic [7:0] char_xy;
    logic [6:0] char_code;
    logic [3:0] char_line;
    //background
    logic [11:0] rom_rgb;
    logic [13:0] rom_addr;
    //zmiana pozycji myszki
    logic first_click_done = 1'b0;
    logic setx, sety;
    logic [11:0] value_x;
    logic [11:0] value_y;
    //bullet
    logic [11:0] rgb_bullet;
    logic [7:0] bullet_addr;
    logic [11:0] bullet_x;
    logic [11:0] bullet_y;


    tbg_if timing_if();
    vga_if draw_bg_if();
    vga_if draw_spaceship_if();
    vga_if draw_mouse_if();
    vga_if draw_char_if();
    vga_if draw_bullet_if();


    /**
     * Signals assignments
     */

    assign vs = draw_mouse_if.vsync;
    assign hs = draw_mouse_if.hsync;
    assign {r,g,b} = draw_mouse_if.rgb[11:0];


    vga_timing u_vga_timing (
        .clk65MHz(clk65MHz),
        .rst,
        .tout(timing_if)
    );

//----------BACKGROUND-----------------

    draw_bg u_draw_bg (
        .clk65MHz(clk65MHz),
        .rst,
        .rom_rgb(rom_rgb),
        .rom_addr(rom_addr),

        .bgin(timing_if),
        .out(draw_bg_if)

    );

    image_bg u_image_bg (
        .clk(clk65MHz),
        .address(rom_addr),
        .rgb(rom_rgb)
    );

//----------SPACESHIP-----------------

    draw_spaceship u_draw_spaceship (
        .clk65MHz(clk65MHz),
        .rst,

        .in (draw_bullet_if),
        .out(draw_spaceship_if),

        .xpos(xpos),
        .ypos(ypos),
        .spaceship_x(spaceship_x),
        .spaceship_y(spaceship_y),
        .left_mouse(left),
        .active_schoot,

        .rgb_pixel,
        .pixel_addr

    );

    image_ship u_image_ship (
        .clk(clk65MHz),

        .rgb(rgb_pixel),
        .address(pixel_addr)

    );

//----------BULLET-----------------
    draw_bullet u_draw_bullet (
        .clk65MHz(clk65MHz),
        .rst,

        .in (draw_char_if),
        .out(draw_bullet_if),

        .spaceship_x(bullet_x),
        .spaceship_y(bullet_y),

        .rgb_bullet,
        .bullet_addr

    );

    image_bullet u_image_bullet (
        .clk(clk65MHz),

        .rgb(rgb_bullet),
        .address(bullet_addr)

    );

    shoot u_shoot (
        .clk(clk65MHz),
        .rst,
        .fire(left),
        .xpos(spaceship_x),
        .ypos(spaceship_y),
        .active_shoot(active_schoot),
        .bullet_x,
        .bullet_y
    );

//----------MOUSE----------------
    draw_mouse u_draw_mouse (
        .clk65MHz(clk65MHz),
        .rst,

        .in(draw_spaceship_if),
        .out(draw_mouse_if),

        .xpos(xpos),
        .ypos(ypos),
        .left_mouse(left),
        .show_cursor()

    );

    always_ff @(posedge clk65MHz) begin
        if (rst)
            first_click_done <= 1'b0;
        else if (left && !first_click_done)
            first_click_done <= 1'b1;
    end

    always_comb begin
        if (left && !first_click_done) begin
            setx = 1'b1;
            sety = 1'b1;
            value_x = START_X;
            value_y = START_Y;
        end else begin
            setx = 1'b0;
            sety = 1'b0;
            value_x = 12'd0;
            value_y = 12'd0;
        end
    end

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
        .value_x(value_x),
        .value_y(value_y),
        .setx(setx),
        .sety(sety),
        .setmax_x('d0),
        .setmax_y('d0),
        .new_event()
    );

//----------------------------

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

    draw_rect_ctl u_draw_rect_ctl (
        .clk(clk_delay),
        .rst,
        .mouse_left(left),
        .mouse_xpos(xpos),
        .mouse_ypos(ypos),
        .xpos(),
        .ypos()
    );

    delay u_delay (
        .clk(clk65MHz),
        .rst,
        .clk_delay(clk_delay)
    );

endmodule
