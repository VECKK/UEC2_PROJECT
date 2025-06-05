module hit_meteor
    #(parameter
        METEOR_W = 150,
        METEOR_H = 150
    )(
        input  logic        clk,
        input  logic        rst,
        input  logic [11:0] bullet_x,
        input  logic [11:0] bullet_y,
        input  logic [11:0] meteor_x,
        input  logic [11:0] meteor_y,
        input  logic meteor_interactive,
        input  logic        bullet_visible,
        output logic        hit,
        output logic        remove_bullet,
        output logic        remove_meteor
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    logic collision;
    
    always_comb begin
        collision = meteor_interactive && bullet_visible &&
            (bullet_x < meteor_x + METEOR_W) &&
            (bullet_x + BULLET_W > meteor_x) &&
            (bullet_y < meteor_y + METEOR_H) &&
            (bullet_y + BULLET_H > meteor_y);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            hit           <= 1'b0;
            remove_bullet <= 1'b0;
            remove_meteor <= 1'b0;
        end else begin
            if (collision) begin
                hit           <= 1'b1;
                remove_bullet <= 1'b1;
                remove_meteor <= 1'b1;
            end else begin
                hit           <= 1'b0;
                remove_bullet <= 1'b0;
                remove_meteor <= 1'b0;
            end
        end
    end

endmodule