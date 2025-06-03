module image_meteor (
        input  logic clk ,
        input  logic [14:0] address,
        output logic [11:0] rgb
    );

    reg [11:0] rom [0:22499]; // 150*150= 22500

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Meteorite/meteor.data", rom);

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule