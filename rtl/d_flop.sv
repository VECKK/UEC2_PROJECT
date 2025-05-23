module d_flop (
    input  logic clk,
    input  logic rst,
    input  logic [11:0] xpos_d,
    input  logic [11:0] ypos_d,
    input  logic left_d,
    output logic [11:0] xpos_q,
    output logic [11:0] ypos_q,
    output logic left_q
);

    always_ff @(posedge clk or posedge rst) begin : d_flop_ff_blk
        if (rst) begin
            xpos_q <= '0;
            ypos_q <= '0;
            left_q <= '0;
        end else begin
            xpos_q <= xpos_d;
            ypos_q <= ypos_d;
            left_q <= left_d;
        end
    end

endmodule