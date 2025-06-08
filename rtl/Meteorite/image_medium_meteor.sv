module image_medium_meteor (
        input  logic clk ,
        input  logic [13:0] address,
        output logic [11:0] rgb
    );

    reg [11:0] rom [0:14399]; // 120*120= 14400

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Meteorite/medium_meteor.data", rom);

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule