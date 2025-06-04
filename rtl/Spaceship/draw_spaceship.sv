module draw_spaceship (
        input  logic clk65MHz,
        input  logic rst,
        input  logic [11:0] xpos,
        input  logic [11:0] ypos,
        input  logic left_mouse,
        input  logic remove,
        input  logic [11:0] rgb_pixel,
        output logic [12:0] pixel_addr,
        output logic [11:0] spaceship_x,
        output logic [11:0] spaceship_y,
        output logic active_schoot,

        vga_if.in in,
        vga_if.out out
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;
    logic [10:0] one_vcount;
    logic [10:0] one_hcount;
    logic [11:0] one_rgb;
    logic        one_vsync, one_vblnk, one_hsync, one_hblnk;
    logic [10:0] two_vcount;
    logic [10:0] two_hcount;
    logic [11:0] two_rgb;
    logic        two_vsync, two_vblnk, two_hsync, two_hblnk;

    logic spaceship_follow_mouse = 1'b0;
    logic armed = 1'b0; 
    logic [3:0] blink_count;         // Licznik mignięć
    logic [22:0] blink_timer;        // Licznik czasu (dla 4 Hz przy 65 MHz: 16_250_000)
    logic        blinking;           // Czy trwa miganie
    logic        blink_visible; 

    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            blinking      <= 1'b0;
            blink_count   <= 4'd0;
            blink_timer   <= 23'd0;
            blink_visible <= 1'b1;
        end else if (remove && !blinking) begin
            // Start migania po zniknięciu
            blinking      <= 1'b1;
            blink_count   <= 4'd0;
            blink_timer   <= 23'd0;
            blink_visible <= 1'b0;
        end else if (blinking) begin
            if (blink_timer < 8_125_000) begin // ok. 0.125 s
                blink_timer <= blink_timer + 1;
            end else begin
                blink_timer   <= 23'd0;
                blink_count   <= blink_count + 1;
                blink_visible <= ~blink_visible;
                if (blink_count == 15) begin
                    blinking      <= 1'b0;
                    blink_visible <= 1'b1; // Po miganiu statek widoczny
                end
            end
        end else begin
            blink_visible <= 1'b1; // Normalnie statek widoczny
        end
    end

    // Po pierwszym kliknięciu prostokąt podąża za myszką
    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            spaceship_follow_mouse <= 1'b0;
            armed <= 1'b0;
        end else if (left_mouse) begin
            if (!spaceship_follow_mouse)
                spaceship_follow_mouse <= 1'b1; 
            else
                armed <= 1'b1; 
        end
    end

    // Wybór pozycji prostokąta
    always_comb begin
        if (spaceship_follow_mouse) begin
            spaceship_x = xpos - (WIDTH / 2);
            spaceship_y = ypos - (HEIGHT / 2);
            active_schoot = armed ? 1'b1 : 1'b0;

            if (xpos > 1023 - (WIDTH / 2))
                spaceship_x = 1023 - WIDTH;
            else if (xpos < (WIDTH / 2)) 
                spaceship_x = 0;
            else
                spaceship_x = xpos - (WIDTH / 2);

            if (ypos > 767 - (HEIGHT / 2))
                spaceship_y = 767 - HEIGHT;
            else if (ypos < (HEIGHT / 2))
                spaceship_y = 0;
            else
                spaceship_y = ypos - (HEIGHT / 2);
        end else begin
            spaceship_x = START_X;
            spaceship_y = START_Y;
            active_schoot = 1'b0;
        end
    end

    always_ff @(posedge clk65MHz) begin : one_ff_blk
        if (rst) begin
            one_vcount <= '0;
            one_vsync  <= '0;
            one_vblnk  <= '0;
            one_hcount <= '0;
            one_hsync  <= '0;
            one_hblnk  <= '0;
            one_rgb    <= '0;
        end else begin
            one_vcount <= in.vcount;
            one_vsync  <= in.vsync;
            one_vblnk  <= in.vblnk;
            one_hcount <= in.hcount;
            one_hsync  <= in.hsync;
            one_hblnk  <= in.hblnk;
            one_rgb    <= in.rgb;
        end
    end

    always_ff @(posedge clk65MHz) begin : two_ff_blk
        if (rst) begin
            two_vcount <= '0;
            two_vsync  <= '0;
            two_vblnk  <= '0;
            two_hcount <= '0;
            two_hsync  <= '0;
            two_hblnk  <= '0;
            two_rgb    <= '0;        
        end else begin
            two_vcount <= one_vcount;
            two_vsync  <= one_vsync;
            two_vblnk  <= one_vblnk;
            two_hcount <= one_hcount;
            two_hsync  <= one_hsync;
            two_hblnk  <= one_hblnk;
            two_rgb    <= one_rgb;
        end
    end

    always_ff @(posedge clk65MHz) begin : spaceship_ff_blk
        if (rst) begin
            out.vcount <= '0;
            out.vsync  <= '0;
            out.vblnk  <= '0;
            out.hcount <= '0;
            out.hsync  <= '0;
            out.hblnk  <= '0;
            out.rgb    <= '0;
        end else begin
            out.vcount <= two_vcount;
            out.vsync  <= two_vsync;
            out.vblnk  <= two_vblnk;
            out.hcount <= two_hcount;
            out.hsync  <= two_hsync;
            out.hblnk  <= two_hblnk;
            out.rgb    <= rgb_nxt;
        end
    end

    always_comb begin : spaceship_comb_blk
        rgb_nxt = two_rgb;

        if (!remove && blink_visible &&
            two_hcount >= spaceship_x && two_hcount < spaceship_x + WIDTH &&
            two_vcount >= spaceship_y && two_vcount < spaceship_y + HEIGHT) begin
            if (rgb_pixel == 12'hE3F) begin
                rgb_nxt = two_rgb; 
            end else begin
                rgb_nxt = rgb_pixel;
            end
        end
    end

    always_comb begin : pixel_addr_comb_blk
        if (!remove &&
            two_hcount >= spaceship_x && two_hcount < spaceship_x + WIDTH &&
            two_vcount >= spaceship_y && two_vcount < spaceship_y + HEIGHT) begin
            pixel_addr = ((two_vcount - spaceship_y) * WIDTH) + (two_hcount - spaceship_x);
        end else begin
            pixel_addr = 0;
        end
    end

endmodule