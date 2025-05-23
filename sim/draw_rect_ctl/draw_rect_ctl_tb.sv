module draw_rect_ctl_tb;

    timeunit 1ns;
    timeprecision 1ps;

    logic rst, clk_delay;
    logic mouse_left;
    logic [11:0] mouse_xpos, mouse_ypos;
    logic [11:0] xpos, ypos;

    draw_rect_ctl_prog u_draw_rect_ctl_prog (
        .rst(rst),
        .clk_delay(clk_delay),
        .mouse_left(mouse_left),
        .mouse_xpos(mouse_xpos),
        .mouse_ypos(mouse_ypos)
    );

    draw_rect_ctl u_draw_rect_ctl(
        .clk(clk_delay),
        .rst(rst),
        .mouse_left(mouse_left),
        .mouse_xpos(mouse_xpos),
        .mouse_ypos(mouse_ypos),
        .xpos(xpos),
        .ypos(ypos)
    );

endmodule
