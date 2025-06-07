module image_lifes (
    input  logic clk ,
    input  logic [12:0] address,
    input  logic [2:0] health, 
    output logic [11:0] rgb
);


/**
 * Local variables and signals
 */

(* rom_style = "block" *) logic [11:0] lifes0_rom [0:5119]; //128 * 40 = 5120
(* rom_style = "block" *) logic [11:0] lifes1_rom [0:5119];
(* rom_style = "block" *) logic [11:0] lifes2_rom [0:5119];
(* rom_style = "block" *) logic [11:0] lifes3_rom [0:5119];
 logic [2:0] lifes_count;


/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */

initial $readmemh("../../rtl/Lifes/lifes0.data", lifes0_rom);
initial $readmemh("../../rtl/Lifes/lifes1.data", lifes1_rom);
initial $readmemh("../../rtl/Lifes/lifes2.data", lifes2_rom);
initial $readmemh("../../rtl/Lifes/lifes3.data", lifes3_rom);

/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    lifes_count <= health; 
    case(lifes_count)
        3'd0: rgb <= lifes0_rom[address]; // No lifes
        3'd1: rgb <= lifes1_rom[address]; // 1 life
        3'd2: rgb <= lifes2_rom[address]; // 2 lifes
        3'd3: rgb <= lifes3_rom[address]; // 3 lifes
        default: rgb <= lifes0_rom[address]; // Default case
    endcase
end

endmodule