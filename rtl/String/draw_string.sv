module draw_string
    #(parameter
        CHAR_XPOS = 128, // X position
        CHAR_YPOS = 215, // Y position
        CHAR_HEIGHT = 12, // height of the character in pixels
        WIDTH = 12, // number of characters in the horizontal direction
        SIZE = 3, // 2^SIZE = 8,
        TEXT = "METEOR SPLIT", // text to be displayed
        COLOUR = 12'hC52,  // color for the character, default is black
        VALUE_BITS = 2,
        logic DYNAMIC = 1'd0 // 1 = dynamic, 0 = static


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
        // Dziesiątki i jedności
        text_dynamic[0] = "0" + ((value / 10) % 10);
        text_dynamic[1] = "0" + (value % 10);
        // Jeśli WIDTH > 2, pozostałe znaki mogą być puste (spacja)
        for (int i = 2; i < WIDTH; i++)
            text_dynamic[i] = " ";
    end


    draw_rect_char
    #( 
        .WIDTH(WIDTH),         // ilość znaków w poziomie
        .CHAR_HEIGHT(CHAR_HEIGHT),// wysokość znaku
        .CHAR_XPOS(CHAR_XPOS), // X pozycja znaku
        .CHAR_YPOS(CHAR_YPOS), // Y pozycja znaku
        .COLOUR(COLOUR), // RGB color for the character
        .SCALE_POWER_OF_2(SIZE) // 2^POWER_OF_2 = 4
        
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
        .use_dynamic_text(DYNAMIC), // 1 = dynamic, 0 = static
        .text(text_dynamic),
        .char_code(char_code)
    );

    font_rom u_font_rom (
        .clk(clk),
        .char_line_pixels(char_line_pixels),
        .addr({char_code, char_line}) // char_code[6:0] + char_line[3:0]
    );


endmodule