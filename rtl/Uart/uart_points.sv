/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module to control UART communication for points
 * 
 **/

module uart_points (
        input  logic clk,
        input  logic rst,
        input  logic [5:0] points,
        input  logic rx_p,
        output logic tx_p,
        output logic [5:0] opp_points
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic tx_uart, rd_uart, rx_empty, wr_uart, wr_uart_nxt, tx_full;
    logic [7:0] r_data, w_data, w_data_nxt;
    logic [5:0] opp_points_nxt;

    assign rd_uart = !rx_empty;

    always_ff @(posedge clk) begin
        if (rst) begin
            tx_p <= 1'b0;
        end else begin
            tx_p <= tx_uart;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            opp_points <= 0;
        end else begin
            opp_points <= opp_points_nxt;
        end
    end

    always_comb begin
        if (!rx_empty) begin
            opp_points_nxt = r_data[5:0];
        end else begin
            opp_points_nxt = opp_points;
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
            w_data_nxt  = {2'b00, points};
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
        .rx(rx_p),
        .w_data,
        .tx(tx_uart),
        .tx_full,
        .rx_empty,
        .r_data
    );

endmodule