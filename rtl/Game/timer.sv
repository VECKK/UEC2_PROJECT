module timer #(
    parameter CLK_FREQ = 65_000_000 // częstotliwość zegara (65 MHz)
)(
    input  logic clk,
    input  logic rst,
    input  logic enable,
    output logic [5:0] seconds,
    output logic [5:0] minutes
);

    logic [$clog2(CLK_FREQ)-1:0] clk_counter;
    logic [5:0] sec_nxt, min_nxt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_counter <= 0;
            sec_nxt     <= 0;
            min_nxt     <= 0;
        end else if (enable) begin
            if (clk_counter == CLK_FREQ-1) begin
                clk_counter <= 0;
                if (sec_nxt == 59) begin
                    sec_nxt <= 0;
                    if (min_nxt == 59)
                        min_nxt <= 0;
                    else
                        min_nxt <= min_nxt + 1;
                end else begin
                    sec_nxt <= sec_nxt + 1;
                end
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

    assign seconds = sec_nxt;
    assign minutes = min_nxt;

endmodule