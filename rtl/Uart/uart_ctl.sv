/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Wiktoria Borycka
 * Co-Author: Kacper Kierzek
 *
 * Description: module to control UART communication for game events
 * 
 **/

module uart_ctl (
        input  logic clk,
        input  logic rst,
        input  logic first_click,
        input  logic endgame,
        input  logic rx,
        output logic tx,
        output logic opp_first_click,
        output logic opp_endgame 
    );

    timeunit 1ns;
    timeprecision 1ps;

    logic tx_uart, rd_uart, rx_empty, wr_uart, wr_uart_nxt, tx_full;
    logic [7:0] r_data, w_data, w_data_nxt;
    logic opp_first_click_nxt, opp_endgame_nxt;

    assign rd_uart = !rx_empty;

    always_ff @(posedge clk) begin
        if (rst) begin
            tx <= 1'b0;
        end else begin
            tx <= tx_uart;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            opp_first_click <= 0;
            opp_endgame <= 0;
        end else begin
            opp_first_click <= opp_first_click_nxt;
            opp_endgame <= opp_endgame_nxt;
 
        end
    end

    always_comb begin
        if (!rx_empty) begin
            opp_first_click_nxt = r_data[0];
            opp_endgame_nxt = r_data[1];
        end else begin
            opp_first_click_nxt = opp_first_click;
            opp_endgame_nxt = opp_endgame;
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
            w_data_nxt  = {6'b0, endgame, first_click};
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
        .rx,
        .w_data,
        .tx(tx_uart),
        .tx_full,
        .rx_empty,
        .r_data
    );

endmodule