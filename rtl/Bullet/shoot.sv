module shoot #(
    parameter SPEED = 2
) (
    input  logic clk,
    input  logic rst,
    input  logic fire,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    input  logic active_shoot,
    output logic [11:0] bullet_x,
    output logic [11:0] bullet_y
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

    always_ff @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            bullet_x   <= 0;
            bullet_y   <= 0;
            xpos_fixed <= 0;
        end else begin
            state    <= next_state;
            bullet_x <= xpos_nxt;
            bullet_y <= ypos_nxt;
            if (state == IDLE && fire && active_shoot) begin
                xpos_fixed <= xpos; // Zapamiętaj pozycję pocisku przy strzale
            end else if (state == UP) begin
                xpos_fixed <= xpos_fixed; // Utrzymuj stałą pozycję x pocisku
            end
        end
    end

    // Stan maszyny
    always_comb begin
        case (state)
            IDLE:    next_state = (fire && active_shoot && (ypos >= 20)) ? UP : IDLE;
            UP:      next_state = (bullet_y <= SPEED) ? IDLE : UP;
            default: next_state = IDLE;
        endcase
    end

    // Pozycje pocisku
    always_comb begin
        case (state)
            IDLE: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end

            UP: begin
                xpos_nxt = xpos_fixed;
                ypos_nxt = bullet_y - SPEED;
            end

            default: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end
        endcase
    end

endmodule