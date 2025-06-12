/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module used for logic behind bullet firing, movement,
 * controlling bullet visibility and position.
 * 
 **/

module shoot 
    #(parameter
        SPEED = 2
    ) (
        input  logic clk,
        input  logic rst,
        input  logic fire,
        input  logic [11:0] xpos,
        input  logic [11:0] ypos,
        input  logic active_shoot,
        input  logic remove,
        output logic [11:0] bullet_x,
        output logic [11:0] bullet_y,
        output logic visible
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        UP   = 2'b01
    } state_t;

    state_t state, next_state;

    logic [11:0] xpos_nxt, ypos_nxt, xpos_fixed;
    logic [16:0] bullet_tick_nxt;

    logic [16:0] bullet_tick;
    logic update_bullet,fire_prev;

    assign update_bullet = (bullet_tick == 0);

    always_comb begin
        if (rst || state != UP)
            bullet_tick_nxt = 0;
        else if (bullet_tick == 84634)
            bullet_tick_nxt = 0;
        else
            bullet_tick_nxt = bullet_tick + 1;
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            bullet_tick <= 0;
        else
            bullet_tick <= bullet_tick_nxt;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            bullet_x   <= 0;
            bullet_y   <= 0;
            xpos_fixed <= 0;
            fire_prev  <= 0;
            visible    <= 0;
        end else begin
            state    <= next_state;
            bullet_x <= xpos_nxt;
            fire_prev <= fire;
            if (update_bullet || state != UP)
                bullet_y <= ypos_nxt;
            xpos_fixed <= (state == IDLE && fire && active_shoot) ? xpos : xpos_fixed;

            if (remove) begin
                visible <= 1'b0; 
            end else if (state == IDLE && fire && fire_prev == 0 && active_shoot && (ypos >= 36)) begin
                visible <= 1'b1; 
            end else if (state == UP && bullet_y <= SPEED) begin
                visible <= 1'b0; 
            end
        end
    end

    always_comb begin
        case (state)
            IDLE:    next_state = (fire == 1 && fire_prev == 0 && active_shoot && (ypos >= 36)) ? UP : IDLE;
            UP:      next_state = (bullet_y <= SPEED) ? IDLE : UP;
            default: next_state = IDLE;
        endcase
    end

    always_comb begin
        case (state)
            IDLE: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end

            UP: begin
                xpos_nxt = xpos_fixed;
                if (update_bullet)
                    ypos_nxt = bullet_y - SPEED;
                else
                    ypos_nxt = bullet_y;
            end

            default: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
        endcase
    end

endmodule