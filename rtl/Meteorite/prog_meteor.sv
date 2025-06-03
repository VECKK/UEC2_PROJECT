module prog_meteor 
    #(parameter
        METEOR_SPEED = 2,
        METEOR_W = 150,
        METEOR_H = 150
    )(
        input  logic        clk,
        input  logic        rst,
        input  logic        start,
        input  logic [11:0] start_x,
        input  logic [11:0] start_y,
        input  logic        direction_condition, // losowy bit: 0 = lewo-dół, 1 = prawo-dół
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

    logic [11:0] xpos_nxt, ypos_nxt;

    // Kierunek na starcie
    always_ff @(posedge clk) begin
        if (rst || start) begin
            meteor_x <= start_x;
            meteor_y <= start_y;
            direction  <= direction_condition ? RIGHT_DOWN : LEFT_DOWN;
        end else begin
            meteor_x <= xpos_nxt;
            meteor_y <= ypos_nxt;
            direction  <= direction_nxt;
        end
    end

   // Blok wyznaczający następny kierunek
    always_comb begin : direction_nxt_blk
        case (direction)
            LEFT_DOWN: begin
                if (meteor_x <= METEOR_SPEED)
                    direction_nxt = RIGHT_DOWN;
                else if (meteor_y >= VER_PIXELS - METEOR_H - METEOR_SPEED)
                    direction_nxt = LEFT_UP;
                else
                    direction_nxt = LEFT_DOWN;
            end
            RIGHT_DOWN: begin
                if (meteor_x >= HOR_PIXELS - METEOR_W - METEOR_SPEED)
                    direction_nxt = LEFT_DOWN;
                else if (meteor_y >= VER_PIXELS - METEOR_H - METEOR_SPEED)
                    direction_nxt = RIGHT_UP;
                else
                    direction_nxt = RIGHT_DOWN;
            end
            LEFT_UP: begin
                if (meteor_x <= 0)
                    direction_nxt = RIGHT_UP;
                else if (meteor_y <= 0)
                    direction_nxt = LEFT_DOWN;
                else
                    direction_nxt = LEFT_UP;
            end
            RIGHT_UP: begin
                if (meteor_x >= HOR_PIXELS - METEOR_W - METEOR_SPEED)
                    direction_nxt = LEFT_UP;
                else if (meteor_y <= METEOR_SPEED)
                    direction_nxt = RIGHT_DOWN;
                else
                    direction_nxt = RIGHT_UP;
            end
            default: direction_nxt = direction;
        endcase
    end

    // Blok wyznaczający następną pozycję
    always_comb begin : pos_nxt_blk
        case (direction_nxt)
            LEFT_DOWN: begin
                xpos_nxt = meteor_x - METEOR_SPEED;
                ypos_nxt = meteor_y + METEOR_SPEED;
            end
            RIGHT_DOWN: begin
                xpos_nxt = meteor_x + METEOR_SPEED;
                ypos_nxt = meteor_y + METEOR_SPEED;
            end
            LEFT_UP: begin
                xpos_nxt = meteor_x - METEOR_SPEED;
                ypos_nxt = meteor_y - METEOR_SPEED;
            end
            RIGHT_UP: begin
                xpos_nxt = meteor_x + METEOR_SPEED;
                ypos_nxt = meteor_y - METEOR_SPEED;
            end
            default: begin
                xpos_nxt = meteor_x;
                ypos_nxt = meteor_y;
            end
        endcase
    end

endmodule