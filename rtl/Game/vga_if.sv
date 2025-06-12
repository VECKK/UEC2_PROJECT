/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: interface for VGA signals used in the game
 * 
 **/

interface vga_if();

    logic [10:0] vcount;
    logic        vsync;
    logic        vblnk;
    logic [10:0] hcount;
    logic        hsync;
    logic        hblnk;

    logic [11:0] rgb;

    modport in (input vcount, vsync, vblnk, hcount, hsync, hblnk, rgb);
    modport out (output vcount, vsync, vblnk, hcount, hsync, hblnk, rgb);

endinterface

interface tbg_if();

    logic [10:0] vcount;
    logic        vsync;
    logic        vblnk;
    logic [10:0] hcount;
    logic        hsync;
    logic        hblnk;

    modport tout (output vcount, vsync, vblnk, hcount, hsync, hblnk);
    modport bgin (input vcount, vsync, vblnk, hcount, hsync, hblnk);

endinterface

