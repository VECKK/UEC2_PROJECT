/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Robert Szczygiel
 * Co-Author: Piotr Kaczmarczyk,
 *            Witkoria Borycka,
 *            Kacper Kierzek
 *
 * Description: image module for medium meteorite used as an enemy sprite
 * 
 * 
 **/

module image_medium_meteor (
        input  logic clk ,
        input  logic [11:0] address,
        output logic [11:0] rgb
    );

    (* ram_style = "distributed" *) logic [11:0] rom [0:4095]; // 64 * 64 = 4096

    /* Relative path from the simulation or synthesis working directory */
    initial $readmemh("../../rtl/Meteorite/medium_meteor.data", rom);

    always_ff @(posedge clk)
        rgb <= rom[address];

endmodule