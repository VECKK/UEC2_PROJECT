# Copyright (C) 2025  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name vga_project

# Top module name                               -- EDIT
set top_module top_vga_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/Game/vga_pkg.sv
    ../rtl/Game/vga_timing.sv
    ../rtl/Game/top_vga.sv
    ../rtl/Game/vga_if.sv
    ../rtl/Game/game_timer.sv
    ../rtl/Lifes/draw_lifes.sv
    ../rtl/Lifes/image_lifes.sv
    ../rtl/Logo/draw_logo.sv
    ../rtl/Logo/image_logo.sv
    ../rtl/Background/draw_bg.sv
    ../rtl/Background/image_bg.sv
    ../rtl/Spaceship/draw_spaceship.sv
    ../rtl/Spaceship/image_ship.sv
    ../rtl/Spaceship/collision.sv
    ../rtl/Bullet/draw_bullet.sv
    ../rtl/Bullet/image_bullet.sv
    ../rtl/Bullet/shoot.sv
    ../rtl/Bullet/hit_meteor.sv
    ../rtl/Meteorite/draw_meteor.sv
    ../rtl/Meteorite/image_meteor.sv
    ../rtl/Meteorite/prog_meteor.sv
    ../rtl/Meteorite/toggle.sv
    ../rtl/Meteorite/random.sv
    ../rtl/String/char_rom.sv
    ../rtl/String/draw_rect_char.sv
    ../rtl/String/draw_string.sv
    ../rtl/String/font_rom.sv
    ../rtl/Mouse/draw_mouse.sv
    rtl/top_vga_basys3.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
     rtl/clk_wiz_0_clk_wiz.v
     rtl/clk_wiz_0.v
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
    ../rtl/Mouse/MouseCtl.vhd
    ../rtl/Mouse/Ps2Interface.vhd
    ../rtl/Mouse/MouseDisplay.vhd
}

# Specify files for a memory initialization     -- EDIT
set mem_files {
    ../rtl/Spaceship/spaceship.data
    ../rtl/Background/background.data
    ../rtl/Bullet/bullet.data
    ../rtl/Meteorite/meteor.data
    ../rtl/Logo/logo.data
    ../rtl/Lifes/lifes0.data
    ../rtl/Lifes/lifes1.data
    ../rtl/Lifes/lifes2.data
    ../rtl/Lifes/lifes3.data
}
