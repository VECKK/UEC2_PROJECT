/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module to draw a string on the screen
 * to display dynamic or static text based on input value and parameters
 * 
 **/

module draw_string
    #(parameter
        CHAR_XPOS = 128, 
        CHAR_YPOS = 215, 
        CHAR_HEIGHT = 12, 
        WIDTH = 12, 
        SIZE = 3, 
        TEXT = "METEOR SPLIT", 
        COLOUR = 12'hC52, 
        VALUE_BITS = 2,
        logic DYNAMIC = 1'd0 
    )(
        input logic clk,
        input logic rst,
        input logic enable,
        input logic [VALUE_BITS - 1:0] value,
        
        vga_if.in in,
        vga_if.out out
    );
        
    logic [7:0] char_xy;
    logic [6:0] char_code;
    logic [3:0] char_line;
    logic [7:0] char_line_pixels;
    logic [6:0] text_dynamic [0:WIDTH - 1];

    always_comb begin

        text_dynamic[0] = "0" + ((value / 10) % 10);
        text_dynamic[1] = "0" + (value % 10);

        for (int i = 2; i < WIDTH; i++)
            text_dynamic[i] = " ";
    end

    draw_rect_char
    #( 
        .WIDTH(WIDTH),         
        .CHAR_HEIGHT(CHAR_HEIGHT),
        .CHAR_XPOS(CHAR_XPOS), 
        .CHAR_YPOS(CHAR_YPOS), 
        .COLOUR(COLOUR), 
        .SCALE_POWER_OF_2(SIZE) 
        
    )u_draw_rect_char_start_screen (
        .clk(clk),
        .rst,

        .enable(enable),
        .char_line_pixels(char_line_pixels),
        .char_xy(char_xy),
        .char_line(char_line),

        .in(in),
        .out(out)
    );

    char_rom 
    #(
        .TEXT(TEXT),
        .TEXT_SIZE(WIDTH)
    )
    u_char_rom_start_screen (
        .clk(clk),
        .char_xy(char_xy),
        .use_dynamic_text(DYNAMIC), 
        .text(text_dynamic),
        .char_code(char_code)
    );

    font_rom u_font_rom (
        .clk(clk),
        .char_line_pixels(char_line_pixels),
        .addr({char_code, char_line})
    );

endmodule