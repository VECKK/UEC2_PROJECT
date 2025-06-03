module toggle (
    input  logic clk,
    input  logic rst,
    output logic toggle
);

    always_ff @(posedge clk) begin
        if (rst)
            toggle <= 1'b0;
        else
            toggle <= ~toggle;
    end

endmodule