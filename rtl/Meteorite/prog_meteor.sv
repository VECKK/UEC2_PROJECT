/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module to implemet meteorite movement in the game,
 *              meteorite moves in a random direction and bounces off the edges of the screen
 * 
 **/


module prog_meteor 
    #(parameter
        METEOR_SPEED = 1400,
        METEOR_W = 150,
        METEOR_H = 150,
        DIRECTION = 1
    )(
        input  logic        clk,
        input  logic        rst,
        input  logic        start,
        input  logic [11:0] start_x,
        input  logic [11:0] start_y,
        input  logic        direction_condition,
        input  logic        enable,
        output logic [11:0] meteor_x,
        output logic [11:0] meteor_y
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    typedef enum logic [1:0] {
        LEFT_DOWN  = 2'b00,
        RIGHT_DOWN = 2'b01,
        LEFT_UP    = 2'b10,
        RIGHT_UP   = 2'b11
    } direction_t;

    direction_t direction, direction_nxt;

    logic [39:0] xpos_q12_28, ypos_q12_28;
    logic [39:0] xpos_nxt_q12_28, ypos_nxt_q12_28;

    always_ff @(posedge clk) begin
        if (rst || start) begin
            xpos_q12_28 <= {start_x, 28'd0};
            ypos_q12_28 <= {start_y, 28'd0};
            meteor_x <= start_x;
            meteor_y <= start_y;
            if (DIRECTION) 
                direction <= direction_condition ? RIGHT_DOWN : LEFT_DOWN;
            else           
                direction <= direction_condition ? RIGHT_UP : LEFT_UP;
        end else if (enable) begin
            xpos_q12_28 <= xpos_nxt_q12_28;
            ypos_q12_28 <= ypos_nxt_q12_28;
            meteor_x <= xpos_q12_28[39:28];
            meteor_y <= ypos_q12_28[39:28];
            direction  <= direction_nxt;
        end
    end

    always_comb begin : direction_nxt_blk
        case (direction)
            LEFT_DOWN: begin
                if (xpos_q12_28 <= METEOR_SPEED)
                    direction_nxt = RIGHT_DOWN;
                else if (ypos_q12_28 >= (VER_PIXELS - METEOR_H) << 28)
                    direction_nxt = LEFT_UP;
                else
                    direction_nxt = LEFT_DOWN;
            end
            RIGHT_DOWN: begin
                if (xpos_q12_28 >= (HOR_PIXELS - METEOR_W) << 28)
                    direction_nxt = LEFT_DOWN;
                else if (ypos_q12_28 >= (VER_PIXELS - METEOR_H) << 28)
                    direction_nxt = RIGHT_UP;
                else
                    direction_nxt = RIGHT_DOWN;
            end
            LEFT_UP: begin
                if (xpos_q12_28 <= METEOR_SPEED)
                    direction_nxt = RIGHT_UP;
                else if (ypos_q12_28 <= METEOR_SPEED)
                    direction_nxt = LEFT_DOWN;
                else
                    direction_nxt = LEFT_UP;
            end
            RIGHT_UP: begin
                if (xpos_q12_28 >= (HOR_PIXELS - METEOR_W) << 28)
                    direction_nxt = LEFT_UP;
                else if (ypos_q12_28 <= METEOR_SPEED)
                    direction_nxt = RIGHT_DOWN;
                else
                    direction_nxt = RIGHT_UP;
            end
            default: direction_nxt = direction;
        endcase
    end

    always_comb begin : pos_nxt_blk
        case (direction_nxt)
            LEFT_DOWN: begin
                xpos_nxt_q12_28 = xpos_q12_28 - METEOR_SPEED;
                ypos_nxt_q12_28 = ypos_q12_28 + METEOR_SPEED;
            end
            RIGHT_DOWN: begin
                xpos_nxt_q12_28 = xpos_q12_28 + METEOR_SPEED;
                ypos_nxt_q12_28 = ypos_q12_28 + METEOR_SPEED;
            end
            LEFT_UP: begin
                xpos_nxt_q12_28 = xpos_q12_28 - METEOR_SPEED;
                ypos_nxt_q12_28 = ypos_q12_28 - METEOR_SPEED;
            end
            RIGHT_UP: begin
                xpos_nxt_q12_28 = xpos_q12_28 + METEOR_SPEED;
                ypos_nxt_q12_28 = ypos_q12_28 - METEOR_SPEED;
            end
            default: begin
                xpos_nxt_q12_28 = xpos_q12_28;
                ypos_nxt_q12_28 = ypos_q12_28;
            end
        endcase
    end

endmodule