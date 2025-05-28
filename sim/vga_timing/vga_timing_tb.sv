/**
 *  Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

module vga_timing_tb;

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;


    /**
     *  Local parameters
     */

    localparam real CLK_PERIOD = 15.3846;     // 65 MHz


    /**
     * Local variables and signals
     */

    logic clk65MHz;
    logic rst;

    tbg_if timing_if();

    /**
     * Clock generation
     */

    initial begin
        clk65MHz = 1'b0;
        forever #(CLK_PERIOD/2) clk65MHz = ~clk65MHz;
    end


    /**
     * Reset generation
     */

    initial begin
        rst = 1'b0;
        #(1.25*CLK_PERIOD) rst = 1'b1;
        rst = 1'b1;
        #(2.00*CLK_PERIOD) rst = 1'b0;
    end


    /**
     * Dut placement
     */

    vga_timing dut(
        .clk65MHz(clk65MHz),
        .rst,
        .tout(timing_if)
    );

    /**
     * Tasks and functions
     */

     task check_reset_state();
        assert(timing_if.vcount == 0) else $error("vcount not reset to 0");
        assert(timing_if.vsync  == 0) else $error("vsync not reset to 0");
        assert(timing_if.vblnk  == 0) else $error("vblnk not reset to 0");
        assert(timing_if.hcount == 0) else $error("hcount not reset to 0");
        assert(timing_if.hsync  == 0) else $error("hsync not reset to 0");
        assert(timing_if.hblnk  == 0) else $error("hblnk not reset to 0");

        $display("Reset state WORKS");
    endtask


    /**
     * Assertions
     */

    property hcount_in_range;
        @(posedge clk65MHz)
        disable iff (rst)
        ##1 (timing_if.hcount >= 0) && (timing_if.hcount < HOR_TOTAL_TIME);
    endproperty

    assert property (hcount_in_range)
        else $error("hcount out of range! hcount = %0d",timing_if.hcount);

    property vcount_in_range;
        @(posedge clk65MHz)
        disable iff (rst)
        ##1 (timing_if.vcount >= 0) && (timing_if.vcount < VER_TOTAL_TIME);
    endproperty

    assert property (vcount_in_range)
        else $error("vcount out of range! vcount = %0d",timing_if.vcount);

    property hblnk_in_time;
        @(posedge timing_if.hblnk)
        disable iff (rst)
        (timing_if.hcount == HOR_BLANK_START - 1);
    endproperty

    assert property (hblnk_in_time)
        else $error("hblnk not in time! hcount = %0d",timing_if.hcount);

    property hblnk_end;
        @(negedge timing_if.hblnk)
        disable iff (rst)
        (timing_if.hcount == HOR_TOTAL_TIME - 1);
    endproperty
    
    assert property (hblnk_end)
        else $error("hblnk end not in time! hcount = %0d",timing_if.hcount);

    property vblnk_in_time;
        @(posedge timing_if.vblnk)
        disable iff (rst)
        (timing_if.vcount == VER_BLANK_START - 1);
    endproperty

    assert property (vblnk_in_time)
        else $error("vblnk not in time! vcount = %0d",timing_if.vcount);

    property vblnk_end;
        @(negedge timing_if.vblnk)
        disable iff (rst)
        (timing_if.vcount == VER_TOTAL_TIME - 1);
    endproperty
    
    assert property (vblnk_end)
        else $error("vblnk end not in time! vcount = %0d",timing_if.vcount);

    property hsync_in_time;
        @(posedge timing_if.hsync)
        disable iff (rst)
        (timing_if.hcount == HOR_SYNC_START - 1);
    endproperty

    assert property (hsync_in_time)
        else $error("hsync not in time! hcount = %0d",timing_if.hcount);

    property hsync_end;
        @(negedge timing_if.hsync)
        disable iff (rst)
        (timing_if.hcount == HOR_SYNC_END - 1);
    endproperty

    assert property (hsync_end)
        else $error("hsync end not in time! hcount = %0d",timing_if.hcount);

    property vsync_in_time;
        @(posedge timing_if.vsync)
        disable iff (rst)
        (timing_if.vcount == VER_SYNC_START - 1);
    endproperty

    assert property (vsync_in_time)
        else $error("vsync not in time! vcount = %0d",timing_if.vcount);

    property vsync_end;
        @(negedge timing_if.vsync)
        disable iff (rst)
        (timing_if.vcount == VER_SYNC_END - 1);
    endproperty
    
    assert property (vsync_end)
        else $error("vsync end not in time! vcount = %0d",timing_if.vcount);


    /**
     * Main test
     */

    initial begin
        $display("------Start Test------");
        @(posedge rst);
        $display("Reset done");
        @(negedge rst);
        $display("Reset canceled");
        check_reset_state();

        wait (timing_if.vsync == 1'b0);
        @(negedge timing_if.vsync);
        @(negedge timing_if.vsync);
        $display("----Test completed----");

        $finish;
    end

endmodule
