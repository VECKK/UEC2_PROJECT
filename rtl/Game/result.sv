module result (
    input  logic clk,
    input  logic rst,
    input  logic [5:0] minutes,
    input  logic [5:0] points,
    input  logic [5:0] seconds,
    input  logic [5:0] opp_minutes,
    input  logic [5:0] opp_points,
    input  logic [5:0] opp_seconds,
    output logic winner,
    output logic loser
);

    always_ff @(posedge clk) begin
        if (rst) begin
            winner <= 1'b0;
            loser  <= 1'b0;
        end else begin
            // Domyślnie remis
            winner <= 1'b0;
            loser  <= 1'b0;

            if (points > opp_points) begin
                winner <= 1'b1;
                loser  <= 1'b0;
            end else if (points < opp_points) begin
                winner <= 1'b0;
                loser  <= 1'b1;
            end else begin
                // Remis punktowy, decyduje czas
                if (minutes < opp_minutes) begin
                    winner <= 1'b1;
                    loser  <= 1'b0;
                end else if (minutes > opp_minutes) begin
                    winner <= 1'b0;
                    loser  <= 1'b1;
                end else begin
                    // Remis minutowy, decydują sekundy
                    if (seconds < opp_seconds) begin
                        winner <= 1'b1;
                        loser  <= 1'b0;
                    end else if (seconds > opp_seconds) begin
                        winner <= 1'b0;
                        loser  <= 1'b1;
                    end else begin
                        // Całkowity remis
                        winner <= 1'b0;
                        loser  <= 1'b0;
                    end
                end
            end
        end
    end
    
endmodule