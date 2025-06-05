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

logic [11:0] xpos, ypos;
//background
logic [11:0] rom_rgb;
logic [13:0] rom_addr;
//logo
logic [11:0] rgb_logo;
logic [13:0] logo_addr;
//string
logic string_toggle;
//zmiana pozycji myszki
logic first_click_done = 1'b0;
logic setx, sety;
logic [11:0] value_x, value_y;
//spaceship
logic [11:0] rgb_pixel;
logic [12:0] pixel_addr;
logic left;
logic [11:0] spaceship_x, spaceship_y;
logic active_shoot;
//bullet
logic [11:0] rgb_bullet;
logic [7:0] bullet_addr;
logic [11:0] bullet_x, bullet_y;
//shooting
logic bullet_visible;
logic remove_bullet, remove_meteor;
logic remove_bullet_v1, remove_bullet_v2;
//meteorite 1
logic [11:0] rgb_meteor;
logic [14:0] meteor_addr;
logic [11:0] start_x, start_y, meteor_x, meteor_y;
logic toggle, start_meteor;
//meteorite 2
logic [11:0] rgb_meteor_v2;
logic [14:0] meteor_addr_v2;
logic [11:0] start_x_v2, start_y_v2, meteor_x_v2, meteor_y_v2;
logic start_v2, remove_meteor_v2;
//collision
logic remove_spaceship, remove_spaceship_v1, remove_spaceship_v2;
logic visible_meteor, visible_meteor_v2, blinking;


tbg_if timing_if();
vga_if draw_bg_if();
vga_if draw_spaceship_if();
vga_if draw_mouse_if();
vga_if draw_title_if();
vga_if draw_string_if();
vga_if draw_bullet_if();
vga_if draw_meteor_if();
vga_if draw_meteor_v2_if();
vga_if draw_logo_if();


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

//---------LOGO----------------
draw_logo u_draw_logo (
    .clk65MHz(clk65MHz),
    .rst(rst),
    .enable(!first_click_done),
    .rgb_logo(rgb_logo),
    .logo_addr(logo_addr),

    .in(draw_bg_if),
    .out(draw_logo_if)
);

image_logo u_image_logo (
    .clk(clk65MHz),
    .rgb(rgb_logo),
    .address(logo_addr)
);

//----------TITLE----------------

draw_string u_draw_title (
    .clk(clk65MHz),
    .rst,

    .enable(!first_click_done),
    .in(draw_logo_if),
    .out(draw_title_if)

);

draw_string
#(
    .CHAR_XPOS(384),
    .CHAR_YPOS(345),
    .CHAR_HEIGHT(12),
    .WIDTH(16),
    .SIZE(1),
    .TEXT(">Click to start<"),
    .COLOUR(12'hFFF)
) u_draw_string (
    .clk(clk65MHz),
    .rst,

    .enable(!first_click_done && string_toggle),
    .in(draw_title_if),
    .out(draw_string_if)

);

toggle u_toggle_string (
    .clk(clk65MHz),
    .rst,
    .toggle(string_toggle)
);


//----------SPACESHIP-----------------

draw_spaceship u_draw_spaceship (
    .clk65MHz(clk65MHz),
    .rst,

    .in (draw_bullet_if),
    .out(draw_spaceship_if),

    .xpos(xpos),
    .ypos(ypos),
    .left_mouse(left),
    .remove(remove_spaceship),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .active_shoot,
    .blinking,

    .rgb_pixel,
    .pixel_addr

);

image_ship u_image_ship (
    .clk(clk65MHz),

    .rgb(rgb_pixel),
    .address(pixel_addr)

);

//--------COLLISION---------------

collision u_collision (
    .clk(clk65MHz),
    .rst,

    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .meteor_interactive(visible_meteor),
    .spaceship_blinking(blinking),

    .collision(),
    .remove_spaceship(remove_spaceship_v1)
);

collision u_collision_v2 (
    .clk(clk65MHz),
    .rst,

    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .meteor_interactive(visible_meteor_v2),
    .spaceship_blinking(blinking),

    .collision(),
    .remove_spaceship(remove_spaceship_v2)
);

assign remove_spaceship = remove_spaceship_v1 | remove_spaceship_v2;

//----------BULLET-----------------
draw_bullet u_draw_bullet (
    .clk65MHz(clk65MHz),
    .rst,

    .in (draw_string_if),
    .out(draw_bullet_if),

    .spaceship_x(bullet_x),
    .spaceship_y(bullet_y),
    .visible(bullet_visible),

    .rgb_bullet,
    .bullet_addr

);

image_bullet u_image_bullet (
    .clk(clk65MHz),

    .rgb(rgb_bullet),
    .address(bullet_addr)

);

//-------------SHOOTING-----------------

shoot u_shoot (
    .clk(clk65MHz),
    .rst,
    .fire(left),
    .xpos(spaceship_x),
    .ypos(spaceship_y),
    .active_shoot(active_shoot),
    .remove(remove_bullet),
    .bullet_x,
    .bullet_y,
    .visible(bullet_visible)
);

//---------METEORITE_1------------
draw_meteor u_draw_meteor (
    .clk65MHz(clk65MHz),
    .rst,

    .in(draw_spaceship_if),
    .out(draw_meteor_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .remove(remove_meteor),
    .start_x,
    .start_y,
    .start_meteor,
    .visible(visible_meteor),

    .rgb_meteor,
    .meteor_addr

);

prog_meteor u_prog_meteor (
    .clk(clk65MHz),
    .rst,
    .start(start_meteor),
    .start_x(start_x),
    .start_y(start_y),
    .direction_condition(toggle),
    .meteor_x,
    .meteor_y
);

image_meteor u_image_meteor (
    .clk(clk65MHz),
    .rgb(rgb_meteor),
    .address(meteor_addr)
);

hit_meteor u_hit_meteor (
    .clk(clk65MHz),
    .rst,
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .meteor_interactive(visible_meteor),
    .bullet_visible(bullet_visible),

    .hit(),
    .remove_bullet(remove_bullet_v1),
    .remove_meteor(remove_meteor)
);

//----------METEORITE_2------------

draw_meteor
#(
    .DELAY(138_500_000), // 2.125s
    .DELAY_BITS(28)
) u_draw_meteor_v2 (
    .clk65MHz(clk65MHz),
    .rst,

    .in(draw_meteor_if),
    .out(draw_meteor_v2_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .remove(remove_meteor_v2),
    .start_x(start_x_v2),
    .start_y(start_y_v2),
    .start_meteor(start_v2),
    .visible(visible_meteor_v2),

    .rgb_meteor(rgb_meteor_v2),
    .meteor_addr(meteor_addr_v2)

);

prog_meteor u_prog_meteor_v2 (
    .clk(clk65MHz),
    .rst,
    .start(start_v2),
    .start_x(start_x_v2),
    .start_y(start_y_v2),
    .direction_condition(toggle),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2)
);

image_meteor u_image_meteor_v2 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_v2),
    .address(meteor_addr_v2)
);

hit_meteor u_hit_meteor_v2 (
    .clk(clk65MHz),
    .rst,
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .meteor_interactive(visible_meteor_v2),
    .bullet_visible(bullet_visible),

    .hit(),
    .remove_bullet(remove_bullet_v2),
    .remove_meteor(remove_meteor_v2)
);

assign remove_bullet = remove_bullet_v1 | remove_bullet_v2;

//----------TOGGLE----------------

toggle #(
    .TOGGLE_MAX(8_125_000 - 1) //0.125s
) u_toggle_meteor (
    .clk(clk65MHz),
    .rst,
    .toggle
);

//----------MOUSE----------------
draw_mouse u_draw_mouse (
    .clk65MHz(clk65MHz),
    .rst,

    .in(draw_meteor_v2_if),
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
        value_x = START_X + (WIDTH / 2);
        value_y = START_Y + (HEIGHT / 2);
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

endmodule