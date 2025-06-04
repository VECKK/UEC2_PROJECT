module image_logo (
    input  logic clk ,
    input  logic [13:0] address,
    output logic [11:0] rgb
);

reg [11:0] rom [0:16383]; // 128*128= 16384

/* Relative path from the simulation or synthesis working directory */
initial $readmemh("../../rtl/Logo/logo.data", rom);

always_ff @(posedge clk)
    rgb <= rom[address];

endmodule