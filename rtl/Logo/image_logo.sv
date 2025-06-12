/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Robert Szczygiel
 * Co-Author: Piotr Kaczmarczyk,
 *            Witkoria Borycka,
 *            Kacper Kierzek
 *
 * Description: image module for game logo
 * 
 **/

module image_logo (
    input  logic clk ,
    input  logic [11:0] address,
    output logic [11:0] rgb
);

reg [11:0] rom [0:4095]; // 64 * 64 = 4096

/* Relative path from the simulation or synthesis working directory */
initial $readmemh("../../rtl/Logo/logo.data", rom);

always_ff @(posedge clk)
    rgb <= rom[address];

endmodule