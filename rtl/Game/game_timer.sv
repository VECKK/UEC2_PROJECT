module game_timer #(
    parameter CLK_FREQ = 65000000 // Clock frequency in Hz (e.g., 65 MHz)
)(
    input  logic clk,          // Clock signal
    input  logic rst,          // Reset signal
    input  logic enable,       // Enable signal (starts the timer)
    output logic [127:0] text  // Timer text output
);

    // Timer signals
    logic [31:0] timer_counter, timer_counter_nxt; // Counter for 1-second intervals
    logic [5:0] seconds, seconds_nxt;        // Seconds (0-59)
    logic [5:0] minutes, minutes_nxt;        // Minutes (0-59)

    // Timer logic
    always_ff @(posedge clk) begin
        if (rst) begin
            timer_counter <= 0;
            timer_counter_nxt <= 0;
            seconds <= 0;
            seconds_nxt <= 0;
            minutes <= 0;
            minutes_nxt <= 0;
        end else if (enable) begin
            if (timer_counter_nxt == CLK_FREQ - 1) begin // 1-second interval
                timer_counter <= 0;
                if (seconds_nxt == 59) begin
                    seconds <= 0;
                    if (minutes_nxt == 59) begin
                        minutes <= 0; // Reset minutes after 59
                    end else begin
                        minutes_nxt <= minutes + 1;
                    end
                end else begin
                    seconds_nxt <= seconds + 1;
                end
            end else begin
                timer_counter_nxt <= timer_counter + 1;
            end
        end
    end

    // Convert timer values to text
    always_ff @(posedge clk) begin
        if (rst) begin
            text <= {"TIME: ", 8'h30, 8'h30, 8'h3A, 8'h30, 8'h30}; // "TIME: 00:00"
        end else begin
            text <= {"TIME: ", 
                     (minutes_nxt / 10) + 8'h30, (minutes_nxt % 10) + 8'h30, 8'h3A, // ":"
                     (seconds_nxt / 10) + 8'h30, (seconds_nxt % 10) + 8'h30}; // "MM:SS"
        end
    end

endmodule