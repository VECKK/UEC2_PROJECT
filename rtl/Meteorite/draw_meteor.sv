module draw_meteor 
    #( parameter
        METEOR_W = 150,
        METEOR_H = 150,
        DELAY = 130_000_000, // ok 2s
        DELAY_BITS = 27
    )(
        input  logic clk65MHz,
        input  logic rst,
        input  logic active_shoot,
        input  logic [11:0] meteor_x,
        input  logic [11:0] meteor_y,
        input  logic remove,
        input  logic [11:0] rgb_meteor,
        output logic [14:0] meteor_addr,
        output logic [11:0] start_x,
        output logic [11:0] start_y,
        output logic start_meteor,
        output logic visible,

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

    logic meteor_visible = 1'b0;
    logic [11:0] meteor_pos_x, meteor_pos_y;
    logic [DELAY_BITS - 1:0] meteor_delay_counter;
    logic        meteor_ready = 1'b0;
    logic [9:0] random_x;
    logic enable_random;

    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            meteor_delay_counter <= 0;
            meteor_ready <= 1'b0;
        end else if (meteor_visible) begin
            meteor_delay_counter <= 0;
            meteor_ready <= 1'b0;
        end else if (active_shoot) begin
            meteor_delay_counter <= meteor_delay_counter + 1;
            if (meteor_delay_counter >= DELAY) begin
                meteor_ready <= 1'b1;
            end
        end
    end

    assign enable_random = (active_shoot && !meteor_visible && meteor_ready);
    
    random u_random (
        .clk(clk65MHz),
        .rst,
        .enable(enable_random),
        .random(random_x)
    );
    
    always_ff @(posedge clk65MHz) begin
        if (rst) begin
            meteor_visible <= 1'b0;
            meteor_pos_x <= 0;
            meteor_pos_y <= 0;
            start_meteor <= 1'b0;
        end else if (remove) begin
            start_meteor <= 1'b0;
            meteor_visible <= 1'b0;
        end else if (active_shoot && !meteor_visible && meteor_ready) begin
            meteor_visible <= 1'b1;
            meteor_pos_x <= {2'b0, random_x};
            meteor_pos_y <= 12'd0;
            start_meteor <= 1'b1;
        end else begin
            start_meteor <= 1'b0;
        end
    end
    
    assign start_x = meteor_pos_x;
    assign start_y = meteor_pos_y;
    assign visible = meteor_visible;

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

    always_comb begin
        rgb_nxt = two_rgb;
        meteor_addr = 0;
        if (meteor_visible &&
            two_hcount >= meteor_x && two_hcount < meteor_x + METEOR_W &&
            two_vcount >= meteor_y && two_vcount < meteor_y + METEOR_H && !two_hblnk && !two_vblnk) begin
            meteor_addr = (two_vcount - meteor_y) * METEOR_W + (two_hcount - meteor_x);
            if (rgb_meteor == 12'hE3F) begin
                rgb_nxt = two_rgb; // Use input RGB if rgb_pixel matches E3F
            end else begin
                rgb_nxt = rgb_meteor;
            end
        end
    end

endmodule