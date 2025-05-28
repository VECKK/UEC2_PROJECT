module image_bg (
        input  logic clk ,
        input  logic [13:0] address,
        output logic [11:0] rgb
    );


    /**
     * Local variables and signals
     */

    reg [11:0] rom [0:12287]; // 128*96 = 12288 pixels

    /**
     * Memory initialization from a file
     */

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Background/background.data", rom);


    /**
     * Internal logic
     */

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule
