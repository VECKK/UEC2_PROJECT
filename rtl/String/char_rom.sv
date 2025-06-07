module char_rom
    #(parameter
        TEXT_SIZE = 12 // Number of characters in the text
    )(
        input logic clk,
        input logic [8*TEXT_SIZE-1:0] text, // Dynamic or static text input
        input logic [7:0] char_xy,          // Character index
        output logic [6:0] char_code        // ASCII code of the character
    );

    logic [6:0] char_code_nxt;

    always_ff @(posedge clk) begin
        char_code <= char_code_nxt;
    end

    always_comb begin
        char_code_nxt = text[(TEXT_SIZE - 1 - char_xy) * 8 +: 8]; // Extract character from text
    end

endmodule
