module uart_seconds (
        input  logic clk,
        input  logic rst,
        input  logic [5:0] seconds,
        input  logic rx_s,
        output logic tx_s,
        output logic [5:0] opp_seconds
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic tx_uart, rd_uart, rx_empty, wr_uart, wr_uart_nxt, tx_full;
    logic [7:0] r_data, w_data, w_data_nxt;
    logic [5:0] opp_seconds_nxt;

    assign rd_uart = !rx_empty;

    always_ff @(posedge clk) begin
        if (rst) begin
            tx_s <= 1'b0;
        end else begin
            tx_s <= tx_uart;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            opp_seconds <= 0;
        end else begin
            opp_seconds <= opp_seconds_nxt;
        end
    end

    always_comb begin
        if (!rx_empty) begin
            opp_seconds_nxt = r_data[5:0];
        end else begin
            opp_seconds_nxt = opp_seconds;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            wr_uart <= 1'b0;
            w_data  <= 8'h00;
        end else begin
            wr_uart <= wr_uart_nxt;
            w_data  <= w_data_nxt;
        end
    end

    always_comb begin
        if (!tx_full) begin
            wr_uart_nxt = 1'b1;
            w_data_nxt  = {2'b00, seconds};
        end else begin
            wr_uart_nxt = 1'b0;
            w_data_nxt  = 8'h00;
        end
    end

    uart#( 
        .DBIT(8), .SB_TICK(16), .DVSR(54), .DVSR_BIT(7), .FIFO_W(1)
    ) u_uart(
        .clk,
        .reset(rst),
        .rd_uart,
        .wr_uart,
        .rx(rx_s),
        .w_data,
        .tx(tx_uart),
        .tx_full,
        .rx_empty,
        .r_data
    );

endmodule