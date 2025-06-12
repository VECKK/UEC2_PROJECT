/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Robert Szczygiel
 * Co-Author: Piotr Kaczmarczyk,
 *            Witkoria Borycka,
 *            Kacper Kierzek
 *
 * Description: image module for hearth used as a player life sprite
 * 
 **/

module image_lifes (
    input  logic clk ,
    input  logic [10:0] address, 
    output logic [11:0] rgb
);


/**
 * Local variables and signals
 */

 (* ram_style = "distributed" *) logic [11:0] life_rom [0:1599]; // 40 * 40 = 1600



/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */

initial $readmemh("../../rtl/Lifes/life.data", life_rom);


/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    rgb <= life_rom[address]; // Default case
end

endmodule