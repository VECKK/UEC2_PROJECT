module image_bullet (
        input  logic clk ,
        input  logic [7:0] address,
        output logic [11:0] rgb
    );

    reg [11:0] rom [0:239]; // 6*40= 240

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Bullet/bullet.data", rom);

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule