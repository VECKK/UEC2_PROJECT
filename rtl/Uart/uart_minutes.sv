/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module to control UART communication for minutes
 * 
 **/

module uart_minutes (
        input  logic clk,
        input  logic rst,
        input  logic [5:0] minutes,
        input  logic rx_m,
        output logic tx_m,
        output logic [5:0] opp_minutes
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic tx_uart, rd_uart, rx_empty, wr_uart, wr_uart_nxt, tx_full;
    logic [7:0] r_data, w_data, w_data_nxt;
    logic [5:0] opp_minutes_nxt;

    assign rd_uart = !rx_empty;

    always_ff @(posedge clk) begin
        if (rst) begin
            tx_m <= 1'b0;
        end else begin
            tx_m <= tx_uart;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            opp_minutes <= 0;
        end else begin
            opp_minutes <= opp_minutes_nxt;
        end
    end

    always_comb begin
        if (!rx_empty) begin
            opp_minutes_nxt = r_data[5:0];
        end else begin
            opp_minutes_nxt = opp_minutes;
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
            w_data_nxt  = {2'b00, minutes};
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
        .rx(rx_m),
        .w_data,
        .tx(tx_uart),
        .tx_full,
        .rx_empty,
        .r_data
    );

endmodule