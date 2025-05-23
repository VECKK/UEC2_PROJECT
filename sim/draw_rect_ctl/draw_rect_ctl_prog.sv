module draw_rect_ctl_prog (
        output logic rst,
        output logic clk_delay,
        output logic mouse_left,
        output logic [11:0] mouse_xpos,
        output logic [11:0] mouse_ypos
    );

    timeunit 1ns;
    timeprecision 1ps;

    localparam CLK_PERIOD = 2_000_000;

        /**
     * Clock generation
     */

    initial begin
        clk_delay = 1'b0;
        forever #(CLK_PERIOD/2) clk_delay = ~clk_delay;
    end

    initial begin
        rst = '1;
        repeat(5) @(posedge clk_delay);
        rst = '0;

        mouse_xpos = 300;
        mouse_ypos = 150;
        @(posedge clk_delay);

        mouse_left = '1;
        repeat(2) @(posedge clk_delay);

        mouse_left = '0;
        repeat(500) @(posedge clk_delay);

        mouse_left = '1;
        repeat(3) @(posedge clk_delay);

        mouse_left = '0;
        repeat(50) @(posedge clk_delay);
        
        $display("Simulation has completed successfully.");
        $finish;
    end

    initial begin
        integer file;
        file = $fopen("../../results/output.csv", "w");
        $fwrite(file, "time [ns]; xpos; ypos \n"); 
        $timeformat(-9, 1, "", 10); 

        @(u_draw_rect_ctl.xpos or u_draw_rect_ctl.ypos);
        $fmonitor(file, "%0t; %0d; %0d", $time, u_draw_rect_ctl.xpos, u_draw_rect_ctl.ypos);
        
        #2_000_000_000;
        $fclose(file);
        $finish;
    end

endmodule
