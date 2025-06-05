module random
    #(parameter
        WIDTH = 10,
        METEOR_W = 150
    )(
        input  logic clk,
        input  logic rst,
        input  logic enable,
        output logic [WIDTH-1:0] random
    );

    import vga_pkg::*;

    logic [WIDTH-1:0] random_nxt;
    logic feedback;

    always_ff @(posedge clk) begin
        if (rst) begin
            random_nxt <= 10'd200;
            feedback   <= '0;
        end else if (enable) begin
            feedback    <= random_nxt[9] ^ random_nxt[7] ^ random_nxt[6] ^ random_nxt[4];
            random_nxt <= {random_nxt[WIDTH-2:0], feedback};
        end
    end

    assign random = random_nxt % (HOR_PIXELS - METEOR_W);

endmodule