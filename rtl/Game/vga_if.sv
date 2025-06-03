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

