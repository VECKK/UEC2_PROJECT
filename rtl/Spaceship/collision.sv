module collision
    #(parameter
        METEOR_W = 150,
        METEOR_H = 150,
        INITIAL_LIVES = 0,
        CLK_FREQ = 65000000, // Clock frequency in Hz (e.g., 65 MHz)
        DELAY_SEC = 2        // Delay in seconds
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
        output logic [2:0]  life_counter,
        output logic        remove_spaceship,
        output logic        end_game
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    logic collision_detected;
    logic [2:0] life_counter_nxt = INITIAL_LIVES;
    logic [31:0] collision_delay_counter; // Counter for delay
    logic collision_delay_active;         // Flag to indicate delay is active

    localparam DELAY_COUNT = CLK_FREQ * DELAY_SEC; // Number of clock cycles for the delay

    always_comb begin
        collision_detected = meteor_interactive && !spaceship_blinking &&
            (spaceship_x < meteor_x + METEOR_W) &&
            (spaceship_x + WIDTH > meteor_x) &&
            (spaceship_y + 10 < meteor_y + METEOR_H) &&
            (spaceship_y + HEIGHT - 10 > meteor_y) &&
            !collision_delay_active; // Prevent collision during delay
    end

    always_ff @(posedge clk) begin: colision_ff_blk
        if (rst) begin
            collision        <= 1'b0;
            remove_spaceship <= 1'b0;
            life_counter     <= INITIAL_LIVES; // Initialize life counter
            life_counter_nxt <= INITIAL_LIVES;
            collision_delay_counter <= '0;
            collision_delay_active <= 1'b0;
        end else begin
            if (collision_detected) begin
                collision        <= 1'b1;
                remove_spaceship <= 1'b1;
                if (life_counter_nxt < 3) begin
                    life_counter <= life_counter_nxt + 1; // Decrement life counter
                end
                collision_delay_active <= 1'b1; // Activate delay
                collision_delay_counter <= DELAY_COUNT; // Initialize delay counter
            end else begin
                collision        <= 1'b0;
                remove_spaceship <= 1'b0;
                life_counter <= life_counter_nxt; // Maintain current life counter
            end

            // Handle delay counter
            if (collision_delay_active) begin
                if (collision_delay_counter > 0) begin
                    collision_delay_counter <= collision_delay_counter - 1;
                end else begin
                    collision_delay_active <= 1'b0; // Deactivate delay after 2 seconds
                end
            end
        end
    end

    always_ff @(posedge clk) begin: end_game_ff_blk
        if (rst) begin
            end_game <= 1'b0;
        end else begin
            if (life_counter_nxt == 0) begin
                end_game <= 1'b1;
            end else begin
                end_game <= 1'b0;
            end
        end
    end

endmodule