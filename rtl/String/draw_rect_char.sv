module draw_rect_char
    #(parameter 
        WIDTH = 32,
        CHAR_HEIGHT = 15,
        CHAR_XPOS = 450,
        CHAR_YPOS = 370,
        SCALE_POWER_OF_2 = 2,  // 2^POWER_OF_2 = 2
        COLOUR = 12'hF00 // RGB color for the character
    )
    (
        input logic clk,
        input logic rst,
        input logic [7:0] char_line_pixels,
        input logic enable,

        output logic [7:0] char_xy,
        output logic [3:0] char_line,
    
        vga_if.in in,
        vga_if.out out
    );

    import vga_pkg::*;

    localparam FULL_WIDTH = CHAR_XPOS + ((WIDTH << 3) << SCALE_POWER_OF_2);
    localparam CHAR_YPOS_MAX = CHAR_YPOS + (CHAR_HEIGHT << SCALE_POWER_OF_2);

    logic [11:0] rgb_one, rgb_two, rgb_three, rgb_nxt;
    logic [10:0] vcount_one, vcount_two, vcount_three;
    logic [10:0] hcount_one, hcount_two, hcount_three;
    logic vsync_one, vsync_two, vsync_three;
    logic vblnk_one, vblnk_two, vblnk_three;
    logic hsync_one, hsync_two, hsync_three;
    logic hblnk_one, hblnk_two, hblnk_three;

    logic [7:0] char_xy_nxt;
    logic [3:0] char_line_nxt;
    logic [7:0] pixel_index;
    logic [2:0] bit_index;

    // Zoptymalizowane obliczenia bez dzielenia
    assign char_xy_nxt = (in.hcount >= CHAR_XPOS)
                         ? (((in.hcount - CHAR_XPOS) >> 3) >> SCALE_POWER_OF_2) // dzielenie przez 32
                         : 0;

    assign char_line_nxt = (vcount_one >= CHAR_YPOS)
                           ? ((vcount_one - CHAR_YPOS) >> SCALE_POWER_OF_2) // dzielenie przez 4
                           : 0;

    always_ff @(posedge clk) begin
        if (rst) begin
            {vcount_one, vsync_one, vblnk_one, hcount_one, hsync_one, hblnk_one, rgb_one} <= '0;
            char_xy <= '0;
            char_line <= '0;
        end else begin
            {vcount_one, vsync_one, vblnk_one, hcount_one, hsync_one, hblnk_one, rgb_one} <=
                {in.vcount, in.vsync, in.vblnk, in.hcount, in.hsync, in.hblnk, in.rgb};
            char_xy <= char_xy_nxt;
            char_line <= char_line_nxt;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            {vcount_two, vsync_two, vblnk_two, hcount_two, hsync_two, hblnk_two, rgb_two} <= '0;
        end else begin
            {vcount_two, vsync_two, vblnk_two, hcount_two, hsync_two, hblnk_two, rgb_two} <=
                {vcount_one, vsync_one, vblnk_one, hcount_one, hsync_one, hblnk_one, rgb_one};
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            {vcount_three, vsync_three, vblnk_three, hcount_three, hsync_three, hblnk_three, rgb_three} <= '0;
        end else begin
            {vcount_three, vsync_three, vblnk_three, hcount_three, hsync_three, hblnk_three, rgb_three} <=
                {vcount_two, vsync_two, vblnk_two, hcount_two, hsync_two, hblnk_two, rgb_two};
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            {out.vcount, out.vsync, out.vblnk, out.hcount, out.hsync, out.hblnk, out.rgb} <= '0;
        end else begin
            {out.vcount, out.vsync, out.vblnk, out.hcount, out.hsync, out.hblnk, out.rgb} <=
                {vcount_three, vsync_three, vblnk_three, hcount_three, hsync_three, hblnk_three, rgb_nxt};
        end
    end

    always_comb begin
        if (hcount_three >= CHAR_XPOS && hcount_three < FULL_WIDTH &&
            vcount_three >= CHAR_YPOS && vcount_three < CHAR_YPOS_MAX && enable) begin

            pixel_index = (hcount_three - CHAR_XPOS) >> SCALE_POWER_OF_2;
            bit_index = 7 - 3'(pixel_index[2:0]);
            if (char_line_pixels[bit_index]) begin
                rgb_nxt = COLOUR; 
            end else begin
                rgb_nxt = rgb_three;
            end
        end else begin
            rgb_nxt = rgb_three;
        end
    end

endmodule
