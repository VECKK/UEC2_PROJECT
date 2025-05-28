package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
    localparam HOR_PIXELS       = 1024;
    localparam VER_PIXELS       = 768;
    localparam HOR_TOTAL_TIME   = 1344;
    localparam HOR_BLANK_START  = 1024;
    localparam HOR_SYNC_START   = 1048;
    localparam HOR_SYNC_END     = 1184;
    localparam VER_TOTAL_TIME   = 806;
    localparam VER_BLANK_START  = 768;
    localparam VER_SYNC_START   = 771;
    localparam VER_SYNC_END     = 777;
    
// Spaceship parameters    
    localparam WIDTH = 78;
    localparam HEIGHT = 72;

    // Pozycja startowa na dole ekranu
    localparam [11:0] START_X = (HOR_PIXELS - WIDTH) / 2;
    localparam [11:0] START_Y = VER_PIXELS - HEIGHT - 20;

endpackage
