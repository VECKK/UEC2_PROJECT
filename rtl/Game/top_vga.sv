/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: Top module for whole VGA game.
 * 
 **/

module top_vga (
    input  logic clk65MHz,
    input  logic rst,
    input  logic rx,
    input  logic rx_s,
    input  logic rx_m,
    input  logic rx_p,
    output logic tx,
    output logic tx_s,
    output logic tx_m,
    output logic tx_p,
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
logic [11:0] logo_addr;
//string
logic string_toggle;
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
logic remove_bullet_v1, remove_bullet_v2, remove_bullet_v3, remove_bullet_medium, remove_bullet_medium_v2, remove_bullet_medium_v3, remove_bullet_medium_v4,
      remove_bullet_medium_v5, remove_bullet_medium_v6, remove_bullet_small, remove_bullet_small_v2, remove_bullet_small_v3, remove_bullet_small_v4, remove_bullet_small_v5, 
      remove_bullet_small_v6, remove_bullet_small_v7, remove_bullet_small_v8 , remove_bullet_small_v9, remove_bullet_small_v10, remove_bullet_small_v11, remove_bullet_small_v12;
//meteorite 1
logic [11:0] rgb_meteor;
logic [13:0] meteor_addr;
logic [11:0] start_x, start_y, meteor_x, meteor_y;
logic toggle, start_meteor, meteor_gone;
//meteorite 2
logic [11:0] rgb_meteor_v2;
logic [13:0] meteor_addr_v2;
logic [11:0] start_x_v2, start_y_v2, meteor_x_v2, meteor_y_v2;
logic start_v2, remove_meteor_v2, meteor_gone_v2;
//meteorite 3
logic [11:0] rgb_meteor_v3;
logic [13:0] meteor_addr_v3;
logic [11:0] start_x_v3, start_y_v3, meteor_x_v3, meteor_y_v3;
logic start_v3, remove_meteor_v3, meteor_gone_v3;
//medium meteorite 1
logic [11:0] rgb_meteor_medium;
logic [11:0] meteor_addr_medium;
logic [11:0] start_x_medium, start_y_medium, meteor_x_medium, meteor_y_medium;
logic start_medium, remove_meteor_medium, meteor_gone_medium;
//medium meteorite 2
logic [11:0] rgb_meteor_medium_v2;
logic [11:0] meteor_addr_medium_v2;
logic [11:0] start_x_medium_v2, start_y_medium_v2, meteor_x_medium_v2, meteor_y_medium_v2;
logic start_medium_v2, remove_meteor_medium_v2, meteor_gone_medium_v2;
//medium meteorite 3
logic [11:0] rgb_meteor_medium_v3;
logic [11:0] meteor_addr_medium_v3;
logic [11:0] start_x_medium_v3, start_y_medium_v3, meteor_x_medium_v3, meteor_y_medium_v3;
logic start_medium_v3, remove_meteor_medium_v3, meteor_gone_medium_v3;
//medium meteorite 4
logic [11:0] rgb_meteor_medium_v4;
logic [11:0] meteor_addr_medium_v4;
logic [11:0] start_x_medium_v4, start_y_medium_v4, meteor_x_medium_v4, meteor_y_medium_v4;
logic start_medium_v4, remove_meteor_medium_v4, meteor_gone_medium_v4;
//medium meteorite 5
logic [11:0] rgb_meteor_medium_v5;
logic [11:0] meteor_addr_medium_v5;
logic [11:0] start_x_medium_v5, start_y_medium_v5, meteor_x_medium_v5, meteor_y_medium_v5;
logic start_medium_v5, remove_meteor_medium_v5, meteor_gone_medium_v5;
//medium meteorite 6
logic [11:0] rgb_meteor_medium_v6;
logic [11:0] meteor_addr_medium_v6;
logic [11:0] start_x_medium_v6, start_y_medium_v6, meteor_x_medium_v6, meteor_y_medium_v6;
logic start_medium_v6, remove_meteor_medium_v6, meteor_gone_medium_v6;
//small meteorite 1
logic [11:0] rgb_meteor_small;
logic [9:0] meteor_addr_small;
logic [11:0] start_x_small, start_y_small, meteor_x_small, meteor_y_small;
logic start_small, remove_meteor_small, meteor_gone_small;
//small meteorite 2
logic [11:0] rgb_meteor_small_v2;
logic [9:0] meteor_addr_small_v2;
logic [11:0] start_x_small_v2, start_y_small_v2, meteor_x_small_v2, meteor_y_small_v2;
logic start_small_v2, remove_meteor_small_v2, meteor_gone_small_v2;
//small meteorite 3
logic [11:0] rgb_meteor_small_v3;
logic [9:0] meteor_addr_small_v3;
logic [11:0] start_x_small_v3, start_y_small_v3, meteor_x_small_v3, meteor_y_small_v3;
logic start_small_v3, remove_meteor_small_v3, meteor_gone_small_v3;
//small meteorite 4
logic [11:0] rgb_meteor_small_v4;
logic [9:0] meteor_addr_small_v4;
logic [11:0] start_x_small_v4, start_y_small_v4, meteor_x_small_v4, meteor_y_small_v4;
logic start_small_v4, remove_meteor_small_v4, meteor_gone_small_v4;
//small meteorite 5
logic [11:0] rgb_meteor_small_v5;
logic [9:0] meteor_addr_small_v5;
logic [11:0] start_x_small_v5, start_y_small_v5, meteor_x_small_v5, meteor_y_small_v5;
logic start_small_v5, remove_meteor_small_v5, meteor_gone_small_v5;
//small meteorite 6
logic [11:0] rgb_meteor_small_v6;
logic [9:0] meteor_addr_small_v6;
logic [11:0] start_x_small_v6, start_y_small_v6, meteor_x_small_v6, meteor_y_small_v6;
logic start_small_v6, remove_meteor_small_v6, meteor_gone_small_v6;
//small meteorite 7
logic [11:0] rgb_meteor_small_v7;
logic [9:0] meteor_addr_small_v7;
logic [11:0] start_x_small_v7, start_y_small_v7, meteor_x_small_v7, meteor_y_small_v7;
logic start_small_v7, remove_meteor_small_v7, meteor_gone_small_v7;
//small meteorite 8
logic [11:0] rgb_meteor_small_v8;
logic [9:0] meteor_addr_small_v8;
logic [11:0] start_x_small_v8, start_y_small_v8, meteor_x_small_v8, meteor_y_small_v8;
logic start_small_v8, remove_meteor_small_v8, meteor_gone_small_v8;
//small meteorite 9
logic [11:0] rgb_meteor_small_v9;
logic [9:0] meteor_addr_small_v9;
logic [11:0] start_x_small_v9, start_y_small_v9, meteor_x_small_v9, meteor_y_small_v9;
logic start_small_v9, remove_meteor_small_v9, meteor_gone_small_v9;
//small meteorite 10
logic [11:0] rgb_meteor_small_v10;
logic [9:0] meteor_addr_small_v10;
logic [11:0] start_x_small_v10, start_y_small_v10, meteor_x_small_v10, meteor_y_small_v10;
logic start_small_v10, remove_meteor_small_v10, meteor_gone_small_v10;
//small meteorite 11
logic [11:0] rgb_meteor_small_v11;
logic [9:0] meteor_addr_small_v11;
logic [11:0] start_x_small_v11, start_y_small_v11, meteor_x_small_v11, meteor_y_small_v11;
logic start_small_v11, remove_meteor_small_v11, meteor_gone_small_v11;
//small meteorite 12
logic [11:0] rgb_meteor_small_v12;
logic [9:0] meteor_addr_small_v12;
logic [11:0] start_x_small_v12, start_y_small_v12, meteor_x_small_v12, meteor_y_small_v12;
logic start_small_v12, remove_meteor_small_v12, meteor_gone_small_v12;
//collision
logic remove_spaceship, remove_spaceship_v1, remove_spaceship_v2, remove_spaceship_v3, remove_spaceship_medium, remove_spaceship_medium_v2,  
      remove_spaceship_medium_v3, remove_spaceship_medium_v4, remove_spaceship_medium_v5, remove_spaceship_medium_v6, remove_spaceship_small, remove_spaceship_small_v2, 
      remove_spaceship_small_v3, remove_spaceship_small_v4, remove_spaceship_small_v5, remove_spaceship_small_v6, remove_spaceship_small_v7, remove_spaceship_small_v8, 
      remove_spaceship_small_v9, remove_spaceship_small_v10, remove_spaceship_small_v11, remove_spaceship_small_v12;
logic visible_meteor, visible_meteor_v2, visible_meteor_v3, visible_meteor_medium, visible_meteor_medium_v2, visible_meteor_medium_v3, visible_meteor_medium_v4,
      visible_meteor_medium_v5, visible_meteor_medium_v6, visible_meteor_small, visible_meteor_small_v2, visible_meteor_small_v3, visible_meteor_small_v4, visible_meteor_small_v5, visible_meteor_small_v6,
      visible_meteor_small_v7, visible_meteor_small_v8, visible_meteor_small_v9, visible_meteor_small_v10, visible_meteor_small_v11, visible_meteor_small_v12;
logic blinking;
logic collision, collision_v2, collision_v3, collision_medium, collision_medium_v2, collision_medium_v3, collision_medium_v4, collision_medium_v5, collision_medium_v6, 
      collision_small, collision_small_v2, collision_small_v3, collision_small_v4, collision_small_v5, collision_small_v6, collision_small_v7, collision_small_v8,
      collision_small_v9, collision_small_v10, collision_small_v11, collision_small_v12;
//lifes
logic [11:0] lifes_rgb;
logic [10:0] lifes_addr;
logic lost_life, end_lifes;
//points
logic hit_all;
logic [1:0] points, points_v2, points_v3, points_medium, points_medium_v2, points_medium_v3, points_medium_v4, points_medium_v5, points_medium_v6, points_small, points_small_v2, 
      points_small_v3, points_small_v4, points_small_v5, points_small_v6, points_small_v7, points_small_v8, points_small_v9, points_small_v10, points_small_v11, points_small_v12;
logic [5:0] total_points;
//timer
logic [5:0] seconds, minutes;
//mouse
logic first_click_done;
//endgame
logic endgame;
//uart
logic [5:0] opp_points, opp_minutes, opp_seconds;
logic opp_first_click, opp_endgame, winner, loser;


tbg_if timing_if();
vga_if draw_bg_if();
vga_if draw_spaceship_if();
vga_if draw_mouse_if();
vga_if draw_title_if();
vga_if draw_string_if();
vga_if draw_bullet_if();
vga_if draw_meteor_if();
vga_if draw_meteor_v2_if();
vga_if draw_meteor_v3_if();
vga_if draw_medium_meteor_if();
vga_if draw_medium_meteor_v2_if();
vga_if draw_medium_meteor_v3_if();
vga_if draw_medium_meteor_v4_if();
vga_if draw_medium_meteor_v5_if();
vga_if draw_medium_meteor_v6_if();
vga_if draw_small_meteor_if();
vga_if draw_small_meteor_v2_if();
vga_if draw_small_meteor_v3_if();
vga_if draw_small_meteor_v4_if();
vga_if draw_small_meteor_v5_if();
vga_if draw_small_meteor_v6_if();
vga_if draw_small_meteor_v7_if();
vga_if draw_small_meteor_v8_if();
vga_if draw_small_meteor_v9_if();
vga_if draw_small_meteor_v10_if();
vga_if draw_small_meteor_v11_if();
vga_if draw_small_meteor_v12_if();
vga_if draw_logo_if();
vga_if draw_lifes_if();
vga_if draw_points_if();
vga_if draw_minutes_if();
vga_if draw_colon_if();
vga_if draw_seconds_if();
vga_if draw_score_if();
vga_if draw_wait_if();
vga_if draw_win_if();
vga_if draw_you_if();
vga_if draw_enemy_if();
vga_if draw_score_v2_if();
vga_if draw_lose_if();
vga_if draw_points_you_if();
vga_if draw_points_enemy_if();
vga_if draw_time_if();
vga_if draw_colon_you_if();
vga_if draw_seconds_you_if();
vga_if draw_minutes_you_if();
vga_if draw_colon_enemy_if();
vga_if draw_seconds_enemy_if();
vga_if draw_minutes_enemy_if();
vga_if draw_restart_if();


assign vs = draw_mouse_if.vsync;
assign hs = draw_mouse_if.hsync;
assign {r,g,b} = draw_mouse_if.rgb[11:0];


vga_timing u_vga_timing (
    .clk65MHz(clk65MHz),
    .rst(rst),
    .tout(timing_if)
);

//----------BACKGROUND----------------------------

draw_bg u_draw_bg (
    .clk65MHz(clk65MHz),
    .rst(rst),
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

//---------LOGO------------------------------------
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

//----------TITLE---------------------------------------

draw_string u_draw_title (
    .clk(clk65MHz),
    .rst(rst),

    .enable(!first_click_done),
    .value(2'b0),
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
    .rst(rst),

    .enable(!first_click_done && string_toggle),
    .value(2'b0),
    .in(draw_title_if),
    .out(draw_string_if)
);

toggle u_toggle_string (
    .clk(clk65MHz),
    .rst(rst),
    .toggle(string_toggle)
);

//----------SPACESHIP-----------------------------------------

draw_spaceship u_draw_spaceship (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in (draw_bullet_if),
    .out(draw_spaceship_if),

    .xpos(xpos),
    .ypos(ypos),
    .left_mouse(first_click_done && opp_first_click),
    .remove(remove_spaceship),
    .endgame(endgame),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .active_shoot(active_shoot),
    .blinking(blinking),

    .rgb_pixel(rgb_pixel),
    .pixel_addr(pixel_addr)
);

image_ship u_image_ship (
    .clk(clk65MHz),
    .rgb(rgb_pixel),
    .address(pixel_addr)

);

//----------LIFES------------------

assign lost_life = collision || collision_v2 || collision_v3 || collision_medium || collision_medium_v2  || collision_medium_v3 || collision_medium_v4 || 
    collision_medium_v5 || collision_medium_v6|| collision_small || collision_small_v2 || collision_small_v3 || collision_small_v4 || collision_small_v5 || 
    collision_small_v6 || collision_small_v7 || collision_small_v8 || collision_small_v9 || collision_small_v10 || collision_small_v11 || collision_small_v12;;

draw_lifes u_draw_lifes (
    .clk65MHz(clk65MHz),
    .rst(rst),
    .enable(active_shoot),
    .lost_life(lost_life),
    .endgame(end_lifes),

    .in(draw_small_meteor_v12_if),
    .out(draw_lifes_if),

    .lifes_rgb(lifes_rgb),
    .lifes_addr(lifes_addr)
);

image_lifes u_image_lifes (
    .clk(clk65MHz),
    .rgb(lifes_rgb),
    .address(lifes_addr)
);

//--------COLLISION-------------------------------------------------

collision u_collision (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .meteor_interactive(visible_meteor),
    .spaceship_blinking(blinking),
    .collision(collision),
    .remove_spaceship(remove_spaceship_v1)
);

collision u_collision_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .meteor_interactive(visible_meteor_v2),
    .spaceship_blinking(blinking),
    .collision(collision_v2),
    .remove_spaceship(remove_spaceship_v2)
);

collision u_collision_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_v3),
    .meteor_y(meteor_y_v3),
    .meteor_interactive(visible_meteor_v3),
    .spaceship_blinking(blinking),
    .collision(collision_v3),
    .remove_spaceship(remove_spaceship_v3)
);

collision
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium),
    .meteor_y(meteor_y_medium),
    .meteor_interactive(visible_meteor_medium),
    .spaceship_blinking(blinking),
    .collision(collision_medium),
    .remove_spaceship(remove_spaceship_medium)
);

collision 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium_v2),
    .meteor_y(meteor_y_medium_v2),
    .meteor_interactive(visible_meteor_medium_v2),
    .spaceship_blinking(blinking),
    .collision(collision_medium_v2),
    .remove_spaceship(remove_spaceship_medium_v2)
);

collision 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium_v3),
    .meteor_y(meteor_y_medium_v3),
    .meteor_interactive(visible_meteor_medium_v3),
    .spaceship_blinking(blinking),
    .collision(collision_medium_v3),
    .remove_spaceship(remove_spaceship_medium_v3)
);

collision 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium_v4),
    .meteor_y(meteor_y_medium_v4),
    .meteor_interactive(visible_meteor_medium_v4),
    .spaceship_blinking(blinking),
    .collision(collision_medium_v4),
    .remove_spaceship(remove_spaceship_medium_v4)
);

collision 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium_v5),
    .meteor_y(meteor_y_medium_v5),
    .meteor_interactive(visible_meteor_medium_v5),
    .spaceship_blinking(blinking),
    .collision(collision_medium_v5),
    .remove_spaceship(remove_spaceship_medium_v5)
);

collision 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_medium_collision_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_medium_v6),
    .meteor_y(meteor_y_medium_v6),
    .meteor_interactive(visible_meteor_medium_v6),
    .spaceship_blinking(blinking),
    .collision(collision_medium_v6),
    .remove_spaceship(remove_spaceship_medium_v6)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
)u_small_collision (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small),
    .meteor_y(meteor_y_small),
    .meteor_interactive(visible_meteor_small),
    .spaceship_blinking(blinking),
    .collision(collision_small),
    .remove_spaceship(remove_spaceship_small)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v2),
    .meteor_y(meteor_y_small_v2),
    .meteor_interactive(visible_meteor_small_v2),
    .spaceship_blinking(blinking),
    .collision(collision_small_v2),
    .remove_spaceship(remove_spaceship_small_v2)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v3),
    .meteor_y(meteor_y_small_v3),
    .meteor_interactive(visible_meteor_small_v3),
    .spaceship_blinking(blinking),
    .collision(collision_small_v3),
    .remove_spaceship(remove_spaceship_small_v3)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v4),
    .meteor_y(meteor_y_small_v4),
    .meteor_interactive(visible_meteor_small_v4),
    .spaceship_blinking(blinking),
    .collision(collision_small_v4),
    .remove_spaceship(remove_spaceship_small_v4)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v5),
    .meteor_y(meteor_y_small_v5),
    .meteor_interactive(visible_meteor_small_v5),
    .spaceship_blinking(blinking),
    .collision(collision_small_v5),
    .remove_spaceship(remove_spaceship_small_v5)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v6),
    .meteor_y(meteor_y_small_v6),
    .meteor_interactive(visible_meteor_small_v6),
    .spaceship_blinking(blinking),
    .collision(collision_small_v6),
    .remove_spaceship(remove_spaceship_small_v6)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v7 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v7),
    .meteor_y(meteor_y_small_v7),
    .meteor_interactive(visible_meteor_small_v7),
    .spaceship_blinking(blinking),
    .collision(collision_small_v7),
    .remove_spaceship(remove_spaceship_small_v7)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v8 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v8),
    .meteor_y(meteor_y_small_v8),
    .meteor_interactive(visible_meteor_small_v8),
    .spaceship_blinking(blinking),
    .collision(collision_small_v8),
    .remove_spaceship(remove_spaceship_small_v8)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v9 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v9),
    .meteor_y(meteor_y_small_v9),
    .meteor_interactive(visible_meteor_small_v9),
    .spaceship_blinking(blinking),
    .collision(collision_small_v9),
    .remove_spaceship(remove_spaceship_small_v9)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v10 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v10),
    .meteor_y(meteor_y_small_v10),
    .meteor_interactive(visible_meteor_small_v10),
    .spaceship_blinking(blinking),
    .collision(collision_small_v10),
    .remove_spaceship(remove_spaceship_small_v10)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v11 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v11),
    .meteor_y(meteor_y_small_v11),
    .meteor_interactive(visible_meteor_small_v11),
    .spaceship_blinking(blinking),
    .collision(collision_small_v11),
    .remove_spaceship(remove_spaceship_small_v11)
);

collision 
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_small_collision_v12 (
    .clk(clk65MHz),
    .rst(rst),
    .spaceship_x(spaceship_x),
    .spaceship_y(spaceship_y),
    .meteor_x(meteor_x_small_v12),
    .meteor_y(meteor_y_small_v12),
    .meteor_interactive(visible_meteor_small_v12),
    .spaceship_blinking(blinking),
    .collision(collision_small_v12),
    .remove_spaceship(remove_spaceship_small_v12)
);

assign remove_spaceship = remove_spaceship_v1 | remove_spaceship_v2 | remove_spaceship_v3 | remove_spaceship_medium | remove_spaceship_medium_v2 | remove_spaceship_medium_v3 | 
    remove_spaceship_medium_v4 | remove_spaceship_medium_v5 | remove_spaceship_medium_v6 | remove_spaceship_small | remove_spaceship_small_v2 | remove_spaceship_small_v3 | remove_spaceship_small_v4 
    | remove_spaceship_small_v5 | remove_spaceship_small_v6 | remove_spaceship_small_v7 | remove_spaceship_small_v8 | remove_spaceship_small_v9 | remove_spaceship_small_v10 | remove_spaceship_small_v11 | remove_spaceship_small_v12;;

//-------HIT METEORITE---------------------------------------------------

hit_meteor u_hit_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .meteor_interactive(visible_meteor),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_v1),
    .remove_meteor(remove_meteor)
);

hit_meteor u_hit_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .meteor_interactive(visible_meteor_v2),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_v2),
    .remove_meteor(remove_meteor_v2)
);

hit_meteor u_hit_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_v3),
    .meteor_y(meteor_y_v3),
    .meteor_interactive(visible_meteor_v3),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_v3),
    .remove_meteor(remove_meteor_v3)
);

hit_meteor 
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium),
    .meteor_y(meteor_y_medium),
    .meteor_interactive(visible_meteor_medium),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium),
    .remove_meteor(remove_meteor_medium)
);

hit_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium_v2),
    .meteor_y(meteor_y_medium_v2),
    .meteor_interactive(visible_meteor_medium_v2),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium_v2),
    .remove_meteor(remove_meteor_medium_v2)
);

hit_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium_v3),
    .meteor_y(meteor_y_medium_v3),
    .meteor_interactive(visible_meteor_medium_v3),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium_v3),
    .remove_meteor(remove_meteor_medium_v3)
);

hit_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium_v4),
    .meteor_y(meteor_y_medium_v4),
    .meteor_interactive(visible_meteor_medium_v4),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium_v4),
    .remove_meteor(remove_meteor_medium_v4)
);

hit_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium_v5),
    .meteor_y(meteor_y_medium_v5),
    .meteor_interactive(visible_meteor_medium_v5),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium_v5),
    .remove_meteor(remove_meteor_medium_v5)
);

hit_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120)
) u_hit_medium_meteor_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_medium_v6),
    .meteor_y(meteor_y_medium_v6),
    .meteor_interactive(visible_meteor_medium_v6),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_medium_v6),
    .remove_meteor(remove_meteor_medium_v6)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small),
    .meteor_y(meteor_y_small),
    .meteor_interactive(visible_meteor_small),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small),
    .remove_meteor(remove_meteor_small)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v2),
    .meteor_y(meteor_y_small_v2),
    .meteor_interactive(visible_meteor_small_v2),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v2),
    .remove_meteor(remove_meteor_small_v2)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v3),
    .meteor_y(meteor_y_small_v3),
    .meteor_interactive(visible_meteor_small_v3),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v3),
    .remove_meteor(remove_meteor_small_v3)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v4),
    .meteor_y(meteor_y_small_v4),
    .meteor_interactive(visible_meteor_small_v4),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v4),
    .remove_meteor(remove_meteor_small_v4)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v5),
    .meteor_y(meteor_y_small_v5),
    .meteor_interactive(visible_meteor_small_v5),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v5),
    .remove_meteor(remove_meteor_small_v5)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v6),
    .meteor_y(meteor_y_small_v6),
    .meteor_interactive(visible_meteor_small_v6),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v6),
    .remove_meteor(remove_meteor_small_v6)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v7 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v7),
    .meteor_y(meteor_y_small_v7),
    .meteor_interactive(visible_meteor_small_v7),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v7),
    .remove_meteor(remove_meteor_small_v7)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v8 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v8),
    .meteor_y(meteor_y_small_v8),
    .meteor_interactive(visible_meteor_small_v8),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v8),
    .remove_meteor(remove_meteor_small_v8)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v9 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v9),
    .meteor_y(meteor_y_small_v9),
    .meteor_interactive(visible_meteor_small_v9),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v9),
    .remove_meteor(remove_meteor_small_v9)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v10 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v10),
    .meteor_y(meteor_y_small_v10),
    .meteor_interactive(visible_meteor_small_v10),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v10),
    .remove_meteor(remove_meteor_small_v10)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v11 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v11),
    .meteor_y(meteor_y_small_v11),
    .meteor_interactive(visible_meteor_small_v11),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v11),
    .remove_meteor(remove_meteor_small_v11)
);

hit_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64)
) u_hit_small_meteor_v12 (
    .clk(clk65MHz),
    .rst(rst),
    .bullet_x(bullet_x),
    .bullet_y(bullet_y),
    .meteor_x(meteor_x_small_v12),
    .meteor_y(meteor_y_small_v12),
    .meteor_interactive(visible_meteor_small_v12),
    .bullet_visible(bullet_visible),
    .remove_bullet(remove_bullet_small_v12),
    .remove_meteor(remove_meteor_small_v12)
);

assign remove_bullet = remove_bullet_v1 | remove_bullet_v2 | remove_bullet_v3 | remove_bullet_medium | remove_bullet_medium_v2 | remove_bullet_medium_v3 | remove_bullet_medium_v4 |
    remove_bullet_medium_v5 | remove_bullet_medium_v6 | remove_bullet_small | remove_bullet_small_v2 | remove_bullet_small_v3 | remove_bullet_small_v4 | remove_bullet_small_v5 | 
    remove_bullet_small_v6 | remove_bullet_small_v7 | remove_bullet_small_v8 | remove_bullet_small_v9 | remove_bullet_small_v10 | remove_bullet_small_v11 | remove_bullet_small_v12;

//----------BULLET-------------------------------------------------------

draw_bullet u_draw_bullet (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in (draw_string_if),
    .out(draw_bullet_if),

    .spaceship_x(bullet_x),
    .spaceship_y(bullet_y),
    .visible(bullet_visible),

    .rgb_bullet(rgb_bullet),
    .bullet_addr(bullet_addr)
);

image_bullet u_image_bullet (
    .clk(clk65MHz),
    .rgb(rgb_bullet),
    .address(bullet_addr)
);

//-------------SHOOTING-----------------------------------------------------

shoot u_shoot (
    .clk(clk65MHz),
    .rst(rst),
    .fire(left),
    .xpos(spaceship_x),
    .ypos(spaceship_y),
    .active_shoot(active_shoot),
    .remove(remove_bullet),
    .bullet_x,
    .bullet_y,
    .visible(bullet_visible)
);

//---------METEORITE_1-----------------------------------------------------

draw_meteor u_draw_meteor (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_spaceship_if),
    .out(draw_meteor_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x),
    .meteor_y(meteor_y),
    .remove(remove_meteor),
    .endgame(endgame),
    .ext_start_x(12'd0),
    .ext_start_y(12'd0),
    .use_external_start(1'b0),
    .enable(1'b1),
    .start_x(start_x),
    .start_y(start_y),
    .start_meteor,
    .visible(visible_meteor),
    .meteor_gone,
    .points(points),

    .rgb_meteor(rgb_meteor),
    .meteor_addr(meteor_addr)
);

prog_meteor u_prog_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_meteor),
    .start_x(start_x),
    .start_y(start_y),
    .direction_condition(toggle),
    .enable(visible_meteor | endgame),
    .meteor_x,
    .meteor_y
);

image_meteor u_image_meteor (
    .clk(clk65MHz),
    .rgb(rgb_meteor),
    .address(meteor_addr)
);

//------MEDIUM_METEORITE_1------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_meteor_v3_if),
    .out(draw_medium_meteor_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium),
    .meteor_y(meteor_y_medium),
    .remove(remove_meteor_medium),
    .endgame(endgame),
    .ext_start_x(start_x),
    .ext_start_y(start_y),
    .use_external_start(meteor_gone),
    .enable(meteor_gone),
    .start_x(start_x_medium),
    .start_y(start_y_medium),
    .start_meteor(start_medium),
    .visible(visible_meteor_medium),
    .meteor_gone(meteor_gone_medium),
    .points(points_medium),

    .rgb_meteor(rgb_meteor_medium),
    .meteor_addr(meteor_addr_medium)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(0)
) u_prog_medium_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium),
    .start_x(start_x_medium),
    .start_y(start_y_medium),
    .direction_condition(toggle),
    .enable(visible_meteor_medium | endgame),
    .meteor_x(meteor_x_medium),
    .meteor_y(meteor_y_medium)
);

image_medium_meteor u_image_medium_meteor (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium),
    .address(meteor_addr_medium)
);

//------SMALL_METEORITE_1------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_v6_if),
    .out(draw_small_meteor_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small),
    .meteor_y(meteor_y_small),
    .remove(remove_meteor_small),
    .endgame(endgame),
    .ext_start_x(start_x_medium),
    .ext_start_y(start_y_medium),
    .use_external_start(meteor_gone_medium),
    .enable(meteor_gone_medium),
    .start_x(start_x_small),
    .start_y(start_y_small),
    .start_meteor(start_small),
    .visible(visible_meteor_small),
    .meteor_gone(meteor_gone_small),
    .points(points_small),

    .rgb_meteor(rgb_meteor_small),
    .meteor_addr(meteor_addr_small)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small),
    .start_x(start_x_small),
    .start_y(start_y_small),
    .direction_condition(toggle),
    .enable(visible_meteor_small | endgame),
    .meteor_x(meteor_x_small),
    .meteor_y(meteor_y_small)
);

image_small_meteor u_image_small_meteor (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small),
    .address(meteor_addr_small)
);

//------SMALL_METEORITE_2------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v2 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_if),
    .out(draw_small_meteor_v2_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v2),
    .meteor_y(meteor_y_small_v2),
    .remove(remove_meteor_small_v2),
    .endgame(endgame),
    .ext_start_x(start_x_medium),
    .ext_start_y(start_y_medium),
    .use_external_start(meteor_gone_medium),
    .enable(meteor_gone_medium),
    .start_x(start_x_small_v2),
    .start_y(start_y_small_v2),
    .start_meteor(start_small_v2),
    .visible(visible_meteor_small_v2),
    .meteor_gone(meteor_gone_small_v2),
    .points(points_small_v2),

    .rgb_meteor(rgb_meteor_small_v2),
    .meteor_addr(meteor_addr_small_v2)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v2),
    .start_x(start_x_small_v2),
    .start_y(start_y_small_v2),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v2 | endgame),
    .meteor_x(meteor_x_small_v2),
    .meteor_y(meteor_y_small_v2)
);

image_small_meteor u_image_small_meteor_v2 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v2),
    .address(meteor_addr_small_v2)
);

//------MEDIUM_METEORITE_2------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor_v2 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_if),
    .out(draw_medium_meteor_v2_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium_v2),
    .meteor_y(meteor_y_medium_v2),
    .remove(remove_meteor_medium_v2),
    .endgame(endgame),
    .ext_start_x(start_x),
    .ext_start_y(start_y),
    .use_external_start(meteor_gone),
    .enable(meteor_gone),
    .start_x(start_x_medium_v2),
    .start_y(start_y_medium_v2),
    .start_meteor(start_medium_v2),
    .visible(visible_meteor_medium_v2),
    .meteor_gone(meteor_gone_medium_v2),
    .points(points_medium_v2),

    .rgb_meteor(rgb_meteor_medium_v2),
    .meteor_addr(meteor_addr_medium_v2)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(1)
) u_prog_medium_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium_v2),
    .start_x(start_x_medium_v2),
    .start_y(start_y_medium_v2),
    .direction_condition(toggle),
    .enable(visible_meteor_medium_v2 | endgame),
    .meteor_x(meteor_x_medium_v2),
    .meteor_y(meteor_y_medium_v2)
);

image_medium_meteor u_image_medium_meteor_v2 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium_v2),
    .address(meteor_addr_medium_v2)
);

//------SMALL_METEORITE_3------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v3 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v2_if),
    .out(draw_small_meteor_v3_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v3),
    .meteor_y(meteor_y_small_v3),
    .remove(remove_meteor_small_v3),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v2),
    .ext_start_y(start_y_medium_v2),
    .use_external_start(meteor_gone_medium_v2),
    .enable(meteor_gone_medium_v2),
    .start_x(start_x_small_v3),
    .start_y(start_y_small_v3),
    .start_meteor(start_small_v3),
    .visible(visible_meteor_small_v3),
    .meteor_gone(meteor_gone_small_v3),
    .points(points_small_v3),

    .rgb_meteor(rgb_meteor_small_v3),
    .meteor_addr(meteor_addr_small_v3)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v3),
    .start_x(start_x_small_v3),
    .start_y(start_y_small_v3),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v3 | endgame),
    .meteor_x(meteor_x_small_v3),
    .meteor_y(meteor_y_small_v3)
);

image_small_meteor u_image_small_meteor_v3 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v3),
    .address(meteor_addr_small_v3)
);

//------SMALL_METEORITE_2------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v4 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v3_if),
    .out(draw_small_meteor_v4_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v4),
    .meteor_y(meteor_y_small_v4),
    .remove(remove_meteor_small_v4),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v2),
    .ext_start_y(start_y_medium_v2),
    .use_external_start(meteor_gone_medium_v2),
    .enable(meteor_gone_medium_v2),
    .start_x(start_x_small_v4),
    .start_y(start_y_small_v4),
    .start_meteor(start_small_v4),
    .visible(visible_meteor_small_v4),
    .meteor_gone(meteor_gone_small_v4),
    .points(points_small_v4),

    .rgb_meteor(rgb_meteor_small_v4),
    .meteor_addr(meteor_addr_small_v4)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v4),
    .start_x(start_x_small_v4),
    .start_y(start_y_small_v4),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v4 | endgame),
    .meteor_x(meteor_x_small_v4),
    .meteor_y(meteor_y_small_v4)
);

image_small_meteor u_image_small_meteor_v4 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v4),
    .address(meteor_addr_small_v4)
);


//----------METEORITE_2----------------------------------------------

draw_meteor
#(
    .DELAY(151_000_000), 
    .DELAY_BITS(28)
) u_draw_meteor_v2 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_meteor_if),
    .out(draw_meteor_v2_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2),
    .remove(remove_meteor_v2),
    .endgame(endgame),
    .ext_start_x(12'd0),
    .ext_start_y(12'd0),
    .use_external_start(1'b0),
    .enable(1'b1),
    .start_x(start_x_v2),
    .start_y(start_y_v2),
    .start_meteor(start_v2),
    .visible(visible_meteor_v2),
    .meteor_gone(meteor_gone_v2),
    .points(points_v2),

    .rgb_meteor(rgb_meteor_v2),
    .meteor_addr(meteor_addr_v2)
);

prog_meteor u_prog_meteor_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_v2),
    .start_x(start_x_v2),
    .start_y(start_y_v2),
    .direction_condition(toggle),
    .enable(visible_meteor_v2 | endgame),
    .meteor_x(meteor_x_v2),
    .meteor_y(meteor_y_v2)
);

image_meteor u_image_meteor_v2 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_v2),
    .address(meteor_addr_v2)
);

//------MEDIUM_METEORITE_3------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor_v3 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_v2_if),
    .out(draw_medium_meteor_v3_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium_v3),
    .meteor_y(meteor_y_medium_v3),
    .remove(remove_meteor_medium_v3),
    .endgame(endgame),
    .ext_start_x(start_x_v2),
    .ext_start_y(start_y_v2),
    .use_external_start(meteor_gone_v2),
    .enable(meteor_gone_v2),
    .start_x(start_x_medium_v3),
    .start_y(start_y_medium_v3),
    .start_meteor(start_medium_v3),
    .visible(visible_meteor_medium_v3),
    .meteor_gone(meteor_gone_medium_v3),
    .points(points_medium_v3),

    .rgb_meteor(rgb_meteor_medium_v3),
    .meteor_addr(meteor_addr_medium_v3)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(0)
) u_prog_medium_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium_v3),
    .start_x(start_x_medium_v3),
    .start_y(start_y_medium_v3),
    .direction_condition(toggle),
    .enable(visible_meteor_medium_v3 | endgame),
    .meteor_x(meteor_x_medium_v3),
    .meteor_y(meteor_y_medium_v3)
);

image_medium_meteor u_image_medium_meteor_v3 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium_v3),
    .address(meteor_addr_medium_v3)
);

//------SMALL_METEORITE_5------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v5 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v4_if),
    .out(draw_small_meteor_v5_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v5),
    .meteor_y(meteor_y_small_v5),
    .remove(remove_meteor_small_v5),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v3),
    .ext_start_y(start_y_medium_v3),
    .use_external_start(meteor_gone_medium_v3),
    .enable(meteor_gone_medium_v3),
    .start_x(start_x_small_v5),
    .start_y(start_y_small_v5),
    .start_meteor(start_small_v5),
    .visible(visible_meteor_small_v5),
    .meteor_gone(meteor_gone_small_v5),
    .points(points_small_v5),

    .rgb_meteor(rgb_meteor_small_v5),
    .meteor_addr(meteor_addr_small_v5)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v5),
    .start_x(start_x_small_v5),
    .start_y(start_y_small_v5),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v5 | endgame),
    .meteor_x(meteor_x_small_v5),
    .meteor_y(meteor_y_small_v5)
);

image_small_meteor u_image_small_meteor_v5 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v5),
    .address(meteor_addr_small_v5)
);

//------SMALL_METEORITE_6------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v6 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v5_if),
    .out(draw_small_meteor_v6_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v6),
    .meteor_y(meteor_y_small_v6),
    .remove(remove_meteor_small_v6),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v3),
    .ext_start_y(start_y_medium_v3),
    .use_external_start(meteor_gone_medium_v3),
    .enable(meteor_gone_medium_v3),
    .start_x(start_x_small_v6),
    .start_y(start_y_small_v6),
    .start_meteor(start_small_v6),
    .visible(visible_meteor_small_v6),
    .meteor_gone(meteor_gone_small_v6),
    .points(points_small_v6),

    .rgb_meteor(rgb_meteor_small_v6),
    .meteor_addr(meteor_addr_small_v6)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v6),
    .start_x(start_x_small_v6),
    .start_y(start_y_small_v6),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v6 | endgame),
    .meteor_x(meteor_x_small_v6),
    .meteor_y(meteor_y_small_v6)
);

image_small_meteor u_image_small_meteor_v6 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v6),
    .address(meteor_addr_small_v6)
);

//------MEDIUM_METEORITE_4------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor_v4 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_v3_if),
    .out(draw_medium_meteor_v4_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium_v4),
    .meteor_y(meteor_y_medium_v4),
    .remove(remove_meteor_medium_v4),
    .endgame(endgame),
    .ext_start_x(start_x_v2),
    .ext_start_y(start_y_v2),
    .use_external_start(meteor_gone_v2),
    .enable(meteor_gone_v2),
    .start_x(start_x_medium_v4),
    .start_y(start_y_medium_v4),
    .start_meteor(start_medium_v4),
    .visible(visible_meteor_medium_v4),
    .meteor_gone(meteor_gone_medium_v4),
    .points(points_medium_v4),

    .rgb_meteor(rgb_meteor_medium_v4),
    .meteor_addr(meteor_addr_medium_v4)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(1)
) u_prog_medium_meteor_v4 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium_v4),
    .start_x(start_x_medium_v4),
    .start_y(start_y_medium_v4),
    .direction_condition(toggle),
    .enable(visible_meteor_medium_v4 | endgame),
    .meteor_x(meteor_x_medium_v4),
    .meteor_y(meteor_y_medium_v4)
);

image_medium_meteor u_image_medium_meteor_v4 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium_v4),
    .address(meteor_addr_medium_v4)
);

//------SMALL_METEORITE_7------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v7 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v6_if),
    .out(draw_small_meteor_v7_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v7),
    .meteor_y(meteor_y_small_v7),
    .remove(remove_meteor_small_v7),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v4),
    .ext_start_y(start_y_medium_v4),
    .use_external_start(meteor_gone_medium_v4),
    .enable(meteor_gone_medium_v4),
    .start_x(start_x_small_v7),
    .start_y(start_y_small_v7),
    .start_meteor(start_small_v7),
    .visible(visible_meteor_small_v7),
    .meteor_gone(meteor_gone_small_v7),
    .points(points_small_v7),

    .rgb_meteor(rgb_meteor_small_v7),
    .meteor_addr(meteor_addr_small_v7)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor_v7 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v7),
    .start_x(start_x_small_v7),
    .start_y(start_y_small_v7),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v7 | endgame),
    .meteor_x(meteor_x_small_v7),
    .meteor_y(meteor_y_small_v7)
);

image_small_meteor u_image_small_meteor_v7 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v7),
    .address(meteor_addr_small_v7)
);

//------SMALL_METEORITE_8------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v8 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v7_if),
    .out(draw_small_meteor_v8_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v8),
    .meteor_y(meteor_y_small_v8),
    .remove(remove_meteor_small_v8),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v4),
    .ext_start_y(start_y_medium_v4),
    .use_external_start(meteor_gone_medium_v4),
    .enable(meteor_gone_medium_v4),
    .start_x(start_x_small_v8),
    .start_y(start_y_small_v8),
    .start_meteor(start_small_v8),
    .visible(visible_meteor_small_v8),
    .meteor_gone(meteor_gone_small_v8),
    .points(points_small_v8),

    .rgb_meteor(rgb_meteor_small_v8),
    .meteor_addr(meteor_addr_small_v8)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v8 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v8),
    .start_x(start_x_small_v8),
    .start_y(start_y_small_v8),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v8 | endgame),
    .meteor_x(meteor_x_small_v8),
    .meteor_y(meteor_y_small_v8)
);

image_small_meteor u_image_small_meteor_v8 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v8),
    .address(meteor_addr_small_v8)
);

//----------METEORITE_3----------------------------------------------

draw_meteor
#(
    .DELAY(141_000_000), 
    .DELAY_BITS(28)
) u_draw_meteor_v3 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_meteor_v2_if),
    .out(draw_meteor_v3_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_v3),
    .meteor_y(meteor_y_v3),
    .remove(remove_meteor_v3),
    .endgame(endgame),
    .ext_start_x(12'd0),
    .ext_start_y(12'd0),
    .use_external_start(1'b0),
    .enable(1'b1),
    .start_x(start_x_v3),
    .start_y(start_y_v3),
    .start_meteor(start_v3),
    .visible(visible_meteor_v3),
    .meteor_gone(meteor_gone_v3),
    .points(points_v3),

    .rgb_meteor(rgb_meteor_v3),
    .meteor_addr(meteor_addr_v3)
);

prog_meteor u_prog_meteor_v3 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_v3),
    .start_x(start_x_v3),
    .start_y(start_y_v3),
    .direction_condition(toggle),
    .enable(visible_meteor_v3 | endgame),
    .meteor_x(meteor_x_v3),
    .meteor_y(meteor_y_v3)
);

image_meteor u_image_meteor_v3 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_v3),
    .address(meteor_addr_v3)
);

//------MEDIUM_METEORITE_5------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor_v5 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_v4_if),
    .out(draw_medium_meteor_v5_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium_v5),
    .meteor_y(meteor_y_medium_v5),
    .remove(remove_meteor_medium_v5),
    .endgame(endgame),
    .ext_start_x(start_x_v3),
    .ext_start_y(start_y_v3),
    .use_external_start(meteor_gone_v3),
    .enable(meteor_gone_v3),
    .start_x(start_x_medium_v5),
    .start_y(start_y_medium_v5),
    .start_meteor(start_medium_v5),
    .visible(visible_meteor_medium_v5),
    .meteor_gone(meteor_gone_medium_v5),
    .points(points_medium_v5),

    .rgb_meteor(rgb_meteor_medium_v5),
    .meteor_addr(meteor_addr_medium_v5)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(0)
) u_prog_medium_meteor_v5 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium_v5),
    .start_x(start_x_medium_v5),
    .start_y(start_y_medium_v5),
    .direction_condition(toggle),
    .enable(visible_meteor_medium_v5 | endgame),
    .meteor_x(meteor_x_medium_v5),
    .meteor_y(meteor_y_medium_v5)
);

image_medium_meteor u_image_medium_meteor_v5 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium_v5),
    .address(meteor_addr_medium_v5)
);

//------SMALL_METEORITE_9------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v9 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v8_if),
    .out(draw_small_meteor_v9_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v9),
    .meteor_y(meteor_y_small_v9),
    .remove(remove_meteor_small_v9),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v5),
    .ext_start_y(start_y_medium_v5),
    .use_external_start(meteor_gone_medium_v5),
    .enable(meteor_gone_medium_v5),
    .start_x(start_x_small_v9),
    .start_y(start_y_small_v9),
    .start_meteor(start_small_v9),
    .visible(visible_meteor_small_v9),
    .meteor_gone(meteor_gone_small_v9),
    .points(points_small_v9),

    .rgb_meteor(rgb_meteor_small_v9),
    .meteor_addr(meteor_addr_small_v9)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor_v9 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v9),
    .start_x(start_x_small_v9),
    .start_y(start_y_small_v9),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v9 | endgame),
    .meteor_x(meteor_x_small_v9),
    .meteor_y(meteor_y_small_v9)
);

image_small_meteor u_image_small_meteor_v9 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v9),
    .address(meteor_addr_small_v9)
);

//------SMALL_METEORITE_10------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v10 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v9_if),
    .out(draw_small_meteor_v10_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v10),
    .meteor_y(meteor_y_small_v10),
    .remove(remove_meteor_small_v10),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v5),
    .ext_start_y(start_y_medium_v5),
    .use_external_start(meteor_gone_medium_v5),
    .enable(meteor_gone_medium_v5),
    .start_x(start_x_small_v10),
    .start_y(start_y_small_v10),
    .start_meteor(start_small_v10),
    .visible(visible_meteor_small_v10),
    .meteor_gone(meteor_gone_small_v10),
    .points(points_small_v10),

    .rgb_meteor(rgb_meteor_small_v10),
    .meteor_addr(meteor_addr_small_v10)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v10 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v10),
    .start_x(start_x_small_v10),
    .start_y(start_y_small_v10),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v10 | endgame),
    .meteor_x(meteor_x_small_v10),
    .meteor_y(meteor_y_small_v10)
);

image_small_meteor u_image_small_meteor_v10 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v10),
    .address(meteor_addr_small_v10)
);

//------MEDIUM_METEORITE_6------------

draw_meteor
#(
    .METEOR_W(120),
    .METEOR_H(120),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(11),
    .POINTS(2),
    .IMG_WIDTH(64)
) u_draw_medium_meteor_v6 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_medium_meteor_v5_if),
    .out(draw_medium_meteor_v6_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_medium_v6),
    .meteor_y(meteor_y_medium_v6),
    .remove(remove_meteor_medium_v6),
    .endgame(endgame),
    .ext_start_x(start_x_v3),
    .ext_start_y(start_y_v3),
    .use_external_start(meteor_gone_v3),
    .enable(meteor_gone_v3),
    .start_x(start_x_medium_v6),
    .start_y(start_y_medium_v6),
    .start_meteor(start_medium_v6),
    .visible(visible_meteor_medium_v6),
    .meteor_gone(meteor_gone_medium_v6),
    .points(points_medium_v6),

    .rgb_meteor(rgb_meteor_medium_v6),
    .meteor_addr(meteor_addr_medium_v6)
);

prog_meteor
#(
    .METEOR_SPEED(1700),
    .METEOR_W(120),
    .METEOR_H(120),
    .DIRECTION(1)
) u_prog_medium_meteor_v6 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_medium_v6),
    .start_x(start_x_medium_v6),
    .start_y(start_y_medium_v6),
    .direction_condition(toggle),
    .enable(visible_meteor_medium_v6 | endgame),
    .meteor_x(meteor_x_medium_v6),
    .meteor_y(meteor_y_medium_v6)
);

image_medium_meteor u_image_medium_meteor_v6 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_medium_v6),
    .address(meteor_addr_medium_v6)
);

//------SMALL_METEORITE_11------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v11 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v10_if),
    .out(draw_small_meteor_v11_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v11),
    .meteor_y(meteor_y_small_v11),
    .remove(remove_meteor_small_v11),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v6),
    .ext_start_y(start_y_medium_v6),
    .use_external_start(meteor_gone_medium_v6),
    .enable(meteor_gone_medium_v6),
    .start_x(start_x_small_v11),
    .start_y(start_y_small_v11),
    .start_meteor(start_small_v11),
    .visible(visible_meteor_small_v11),
    .meteor_gone(meteor_gone_small_v11),
    .points(points_small_v11),

    .rgb_meteor(rgb_meteor_small_v11),
    .meteor_addr(meteor_addr_small_v11)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(0)
) u_prog_small_meteor_v11 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v11),
    .start_x(start_x_small_v11),
    .start_y(start_y_small_v11),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v11 | endgame),
    .meteor_x(meteor_x_small_v11),
    .meteor_y(meteor_y_small_v11)
);

image_small_meteor u_image_small_meteor_v11 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v11),
    .address(meteor_addr_small_v11)
);

//------SMALL_METEORITE_12------------

draw_meteor
#(
    .METEOR_W(64),
    .METEOR_H(64),
    .DELAY(1),
    .DELAY_BITS(2),
    .ADDR(9),
    .POINTS(3),
    .IMG_WIDTH(32)
) u_draw_small_meteor_v12 (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_small_meteor_v11_if),
    .out(draw_small_meteor_v12_if),

    .active_shoot(active_shoot),
    .meteor_x(meteor_x_small_v12),
    .meteor_y(meteor_y_small_v12),
    .remove(remove_meteor_small_v12),
    .endgame(endgame),
    .ext_start_x(start_x_medium_v6),
    .ext_start_y(start_y_medium_v6),
    .use_external_start(meteor_gone_medium_v6),
    .enable(meteor_gone_medium_v6),
    .start_x(start_x_small_v12),
    .start_y(start_y_small_v12),
    .start_meteor(start_small_v12),
    .visible(visible_meteor_small_v12),
    .meteor_gone(meteor_gone_small_v12),
    .points(points_small_v12),

    .rgb_meteor(rgb_meteor_small_v12),
    .meteor_addr(meteor_addr_small_v12)
);

prog_meteor
#(
    .METEOR_SPEED(2000),
    .METEOR_W(64),
    .METEOR_H(64),
    .DIRECTION(1)
) u_prog_small_meteor_v12 (
    .clk(clk65MHz),
    .rst(rst),
    .start(start_small_v12),
    .start_x(start_x_small_v12),
    .start_y(start_y_small_v12),
    .direction_condition(toggle),
    .enable(visible_meteor_small_v12 | endgame),
    .meteor_x(meteor_x_small_v12),
    .meteor_y(meteor_y_small_v12)
);

image_small_meteor u_image_small_meteor_v12 (
    .clk(clk65MHz),
    .rgb(rgb_meteor_small_v12),
    .address(meteor_addr_small_v12)
);

assign endgame = (meteor_gone && meteor_gone_v2 && meteor_gone_v3 && meteor_gone_medium && meteor_gone_medium_v2 && meteor_gone_medium_v3
                && meteor_gone_medium_v4 && meteor_gone_medium_v5 && meteor_gone_medium_v6 && meteor_gone_small && meteor_gone_small_v2 && meteor_gone_small_v3 && meteor_gone_small_v4 
                && meteor_gone_small_v5 && meteor_gone_small_v6 && meteor_gone_small_v7 && meteor_gone_small_v8 && meteor_gone_small_v9 && meteor_gone_small_v10 && meteor_gone_small_v11 
                && meteor_gone_small_v12) || end_lifes;

assign hit_all = (meteor_gone && meteor_gone_v2 && meteor_gone_v3 && meteor_gone_medium && meteor_gone_medium_v2 && meteor_gone_medium_v3
                && meteor_gone_medium_v4 && meteor_gone_medium_v5 && meteor_gone_medium_v6 && meteor_gone_small && meteor_gone_small_v2 && meteor_gone_small_v3 && meteor_gone_small_v4 
                && meteor_gone_small_v5 && meteor_gone_small_v6 && meteor_gone_small_v7 && meteor_gone_small_v8 && meteor_gone_small_v9 && meteor_gone_small_v10 && meteor_gone_small_v11 
                && meteor_gone_small_v12) && !end_lifes;

//-----------TOGGLE-------------

toggle #(
    .TOGGLE_MAX(650_000 - 1)
) u_toggle_meteor (
    .clk(clk65MHz),
    .rst(rst),
    .toggle
);

//--------POINTS--------------------------------------------

points u_points (
    .clk(clk65MHz),
    .rst(rst),
    .endgame(endgame),
    .hit_all(hit_all),
    .points(points),
    .points_v2(points_v2),
    .points_v3(points_v3),
    .points_medium(points_medium),
    .points_medium_v2(points_medium_v2),
    .points_medium_v3(points_medium_v3),
    .points_medium_v4(points_medium_v4),
    .points_medium_v5(points_medium_v5),
    .points_medium_v6(points_medium_v6),
    .points_small(points_small),
    .points_small_v2(points_small_v2),
    .points_small_v3(points_small_v3),
    .points_small_v4(points_small_v4),
    .points_small_v5(points_small_v5),
    .points_small_v6(points_small_v6),
    .points_small_v7(points_small_v7),
    .points_small_v8(points_small_v8),
    .points_small_v9(points_small_v9),
    .points_small_v10(points_small_v10),
    .points_small_v11(points_small_v11),
    .points_small_v12(points_small_v12),
    .total_points(total_points)
);

draw_string
#(
    .CHAR_XPOS(474),
    .CHAR_YPOS(10),
    .CHAR_HEIGHT(12),
    .WIDTH(5),
    .SIZE(1),
    .TEXT("SCORE"),
    .COLOUR(12'hFFF)
) u_draw_score (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .value(2'b0), 
    .in(draw_lifes_if),
    .out(draw_score_if)
);

draw_string
#(
    .CHAR_XPOS(497),
    .CHAR_YPOS(40),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_points (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .value(total_points[5:0]),
    .in(draw_score_if),
    .out(draw_points_if)
);

//--------TIMER--------------------------------------------

timer u_timer (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .seconds,
    .minutes
);

draw_string
#(
    .CHAR_XPOS(928),
    .CHAR_YPOS(725),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_minutes (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .value(minutes[5:0]),
    .in(draw_colon_if),
    .out(draw_minutes_if)
);

draw_string
#(
    .CHAR_XPOS(940),
    .CHAR_YPOS(725),
    .CHAR_HEIGHT(12),
    .WIDTH(3),
    .SIZE(1),
    .TEXT(" : "),
    .COLOUR(12'hFFF)
) u_draw_colon (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .value(2'b0), 
    .in(draw_points_if),
    .out(draw_colon_if)
);

draw_string
#(
    .CHAR_XPOS(970),
    .CHAR_YPOS(725),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_seconds (
    .clk(clk65MHz),
    .rst(rst),
    .enable(active_shoot && !endgame),
    .value(seconds[5:0]),
    .in(draw_minutes_if),
    .out(draw_seconds_if)
);

//----------MOUSE--------------------------------------------

draw_mouse u_draw_mouse (
    .clk65MHz(clk65MHz),
    .rst(rst),

    .in(draw_restart_if),
    .out(draw_mouse_if),

    .xpos(xpos),
    .ypos(ypos),
    .left_mouse(left),
    .endgame(endgame),
    .show_cursor()
);

buttons_ctl u_buttons_ctl (
    .clk(clk65MHz),
    .rst(rst),
    .first_click_done(first_click_done),
    .xpos(xpos),
    .ypos(ypos),
    .left(left),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data)
);

//---------WAIT FOR ENEMY----------------------------------

draw_string
#(
    .CHAR_XPOS(384),
    .CHAR_YPOS(345),
    .CHAR_HEIGHT(16),
    .WIDTH(16),
    .SIZE(1),
    .TEXT(">Wait for enemy<"),
    .COLOUR(12'hFFF)
) u_draw_wait (
    .clk(clk65MHz),
    .rst(rst),

    .enable((first_click_done && string_toggle && !opp_first_click) 
                || (string_toggle && endgame && !opp_endgame)),
    .value(2'b0), 
    .in(draw_seconds_if),
    .out(draw_wait_if)

);

//------------UART-------------------------------------------

uart_ctl u_uart_ctl(
    .clk(clk65MHz),
    .rst(rst),
    .endgame(endgame),
    .first_click(first_click_done),
    .rx(rx),
    .tx(tx),
    .opp_endgame(opp_endgame),
    .opp_first_click(opp_first_click)
);

uart_seconds u_uart_seconds(
    .clk(clk65MHz),
    .rst(rst),
    .seconds(seconds),
    .rx_s(rx_s),
    .tx_s(tx_s),
    .opp_seconds(opp_seconds)
);

uart_minutes u_uart_minutes(
    .clk(clk65MHz),
    .rst(rst),
    .minutes(minutes),
    .rx_m(rx_m),
    .tx_m(tx_m),
    .opp_minutes(opp_minutes)
);

uart_points u_uart_points(
    .clk(clk65MHz),
    .rst(rst),
    .points(total_points),
    .rx_p(rx_p),
    .tx_p(tx_p),
    .opp_points(opp_points)
);

//--------ENDGAME--------------------------------------------

result u_result (
    .clk(clk65MHz),
    .rst(rst),
    .minutes(minutes),
    .seconds(seconds),
    .points(total_points),
    .opp_minutes(opp_minutes),
    .opp_seconds(opp_seconds),
    .opp_points(opp_points),
    .winner(winner),
    .loser(loser)
);

draw_string
#(
    .CHAR_XPOS(270),
    .CHAR_YPOS(110),
    .CHAR_HEIGHT(12),
    .WIDTH(8),
    .SIZE(3),
    .TEXT("YOU WIN!"),
    .COLOUR(12'h0F0) // zielony
) u_draw_win (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame && winner),
    .value(2'b0), 
    .in(draw_wait_if),
    .out(draw_win_if)
);

draw_string
#(
    .CHAR_XPOS(256),
    .CHAR_YPOS(110),
    .CHAR_HEIGHT(12),
    .WIDTH(8),
    .SIZE(3),
    .TEXT("YOU LOSE"),
    .COLOUR(12'hF00) // czerwony
) u_draw_lose (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame && loser),
    .value(2'b0), 
    .in(draw_win_if),
    .out(draw_lose_if)
);

draw_string
#(
    .CHAR_XPOS(208),
    .CHAR_YPOS(300),
    .CHAR_HEIGHT(12),
    .WIDTH(3),
    .SIZE(2),
    .TEXT("YOU"),
    .COLOUR(12'h0FF) // błękit
) u_draw_you (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_lose_if),
    .out(draw_you_if)
);

draw_string
#(
    .CHAR_XPOS(688),
    .CHAR_YPOS(300),
    .CHAR_HEIGHT(12),
    .WIDTH(5),
    .SIZE(2),
    .TEXT("ENEMY"),
    .COLOUR(12'hFF0) // żółty
) u_draw_enemy (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_you_if),
    .out(draw_enemy_if)
);

//-------POINTS-------------

draw_string
#(
    .CHAR_XPOS(474),
    .CHAR_YPOS(365),
    .CHAR_HEIGHT(12),
    .WIDTH(5),
    .SIZE(1),
    .TEXT("SCORE"),
    .COLOUR(12'hFFF)
) u_draw_score_v2 (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_enemy_if),
    .out(draw_score_v2_if)
);

draw_string
#(
    .CHAR_XPOS(240),
    .CHAR_YPOS(395),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_points_you (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(total_points[5:0]),
    .in(draw_score_v2_if),
    .out(draw_points_you_if)
);

draw_string
#(
    .CHAR_XPOS(752),
    .CHAR_YPOS(395),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_points_enemy (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(opp_points[5:0]),
    .in(draw_points_you_if),
    .out(draw_points_enemy_if)
);

//------TIMER_YOU--------

draw_string
#(
    .CHAR_XPOS(480),
    .CHAR_YPOS(440),
    .CHAR_HEIGHT(12),
    .WIDTH(4),
    .SIZE(1),
    .TEXT("TIME"),
    .COLOUR(12'hFFF)
) u_draw_time (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_points_enemy_if),
    .out(draw_time_if)
);

draw_string
#(
    .CHAR_XPOS(216),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_minutes_you (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(minutes[5:0]),
    .in(draw_colon_you_if),
    .out(draw_minutes_you_if)

);

draw_string
#(
    .CHAR_XPOS(228),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(3),
    .SIZE(1),
    .TEXT(" : "),
    .COLOUR(12'hFFF)
) u_draw_colon_you (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_time_if),
    .out(draw_colon_you_if)
);

draw_string
#(
    .CHAR_XPOS(258),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_seconds_you (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(seconds[5:0]),
    .in(draw_minutes_you_if),
    .out(draw_seconds_you_if)

);

//------TIMER_ENEMY--------

draw_string
#(
    .CHAR_XPOS(728),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_minutes_enemy (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(opp_minutes[5:0]),
    .in(draw_colon_enemy_if),
    .out(draw_minutes_enemy_if)
);

draw_string
#(
    .CHAR_XPOS(740),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(3),
    .SIZE(1),
    .TEXT(" : "),
    .COLOUR(12'hFFF)
) u_draw_colon_enemy (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(2'b0), 
    .in(draw_seconds_you_if),
    .out(draw_colon_enemy_if)
);

draw_string
#(
    .CHAR_XPOS(770),
    .CHAR_YPOS(470),
    .CHAR_HEIGHT(12),
    .WIDTH(2),
    .SIZE(1),
    .TEXT("00"),
    .COLOUR(12'hFFF),
    .DYNAMIC(1'b1),
    .VALUE_BITS(6) 
) u_draw_seconds_enemy (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && opp_endgame),
    .value(opp_seconds[5:0]),
    .in(draw_minutes_enemy_if),
    .out(draw_seconds_enemy_if)
);

//----------RESET--------------------------------------------

// game_reset u_game_reset (
//     .clk(clk65MHz),
//     .rst(rst),
//     .endgame(endgame && opp_endgame),
//     .right(right_click_done && opp_right_click),
//     .reset_game(reset_game)
// );

draw_string
#(
    .CHAR_XPOS(232),
    .CHAR_YPOS(590),
    .CHAR_HEIGHT(16),
    .WIDTH(35),
    .SIZE(1),
    .TEXT(">Click RESET button to start again<"),
    .COLOUR(12'hFFF)
) u_draw_restart (
    .clk(clk65MHz),
    .rst(rst),
    .enable(endgame && string_toggle && opp_endgame),
    .value(2'b0), 
    .in(draw_seconds_enemy_if),
    .out(draw_restart_if)
);

//-----------------------------------------------------------

endmodule