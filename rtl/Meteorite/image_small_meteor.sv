/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Robert Szczygiel
 * Co-Author: Piotr Kaczmarczyk,
 *            Witkoria Borycka,
 *            Kacper Kierzek
 *
 * Description: image module for small meteorite used as an enemy sprite
 * 
 * 
 **/

module image_small_meteor (
        input  logic clk ,
        input  logic [9:0] address,
        output logic [11:0] rgb
    );

    (* ram_style = "distributed" *) logic [11:0] rom [0:1023]; // 32 * 32 = 1024

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Meteorite/small_meteor.data", rom);

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule