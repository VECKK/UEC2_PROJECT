module shoot 
    #(parameter
        SPEED = 2
    )
    (
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

    // Add this counter for bullet update timing
    logic [16:0] bullet_tick; // Enough bits for 0..84635
    logic update_bullet,fire_prev, armed;

    assign update_bullet = (bullet_tick == 0);

    always_ff @(posedge clk) begin
        if (rst || state != UP)
            bullet_tick <= 0;
        else if (bullet_tick == 84634)
            bullet_tick <= 0;
        else
            bullet_tick <= bullet_tick + 1;
    end

    always_ff @(posedge clk) begin
        if (rst)
            armed <= 1'b0;
        else if (active_shoot && !armed)
            armed <= 1'b1;
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
            // Only update bullet_y when update_bullet is high or not in UP state
            if (update_bullet || state != UP)
                bullet_y <= ypos_nxt;
            xpos_fixed <= (state == IDLE && fire && active_shoot) ? xpos : xpos_fixed;

            if (remove) begin
                visible <= 1'b0; // pocisk znika po kolizji
            end else if (state == IDLE && fire && fire_prev == 0 && active_shoot && armed && (ypos >= 36)) begin
                visible <= 1'b1; // pocisk pojawia się po wystrzale
            end else if (state == UP && bullet_y <= SPEED) begin
                visible <= 1'b0; // pocisk znika po wylocie poza ekran
            end
        end
    end

    // Stan maszyny
    always_comb begin
        case (state)
            // Only allow shooting if 'armed' is already set (i.e., after first click)
            IDLE:    next_state = (fire == 1 && fire_prev == 0 && active_shoot && armed && (ypos >= 36)) ? UP : IDLE;
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