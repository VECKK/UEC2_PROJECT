module collision
    #(parameter
        METEOR_W = 150,
        METEOR_H = 150
    )(
        input  logic        clk,
        input  logic        rst,
        input  logic [11:0] spaceship_x,
        input  logic [11:0] spaceship_y,
        input  logic [11:0] meteor_x,
        input  logic [11:0] meteor_y,
        input  logic        meteor_interactive,
        input  logic        spaceship_blinking,
        output logic        collision,
        output logic        remove_spaceship
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    logic collision_detected;

    always_comb begin
        collision_detected = meteor_interactive && !spaceship_blinking &&
            (spaceship_x < meteor_x + METEOR_W) &&
            (spaceship_x + WIDTH > meteor_x) &&
            (spaceship_y - 10 < meteor_y + METEOR_H) &&
            (spaceship_y - 10 + HEIGHT - 10 > meteor_y);
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            collision        <= 1'b0;
            remove_spaceship <= 1'b0;
        end else begin
            if (collision_detected) begin
                collision        <= 1'b1;
                remove_spaceship <= 1'b1;
            end else begin
                collision        <= 1'b0;
                remove_spaceship <= 1'b0;
            end
        end
    end

endmodule