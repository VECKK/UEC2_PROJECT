module char_rom 
    #(parameter string TEXT = 
    {
        "START GAME"
    },
        parameter TEXT_SIZE = 10
    ) 
    (
        input  logic       clk,
        input  logic [7:0] char_xy,
        input  logic       use_dynamic_text, // 1 = dynamiczny, 0 = stały
        input  logic [6:0] text [0:TEXT_SIZE - 1],
        output logic [6:0] char_code    // 7-bit ASCII output
    );

    logic [6:0] char_code_nxt;
    logic [7:0] rom [0:TEXT_SIZE - 1];

    initial begin : init_rom
        for (int i = 0; i < TEXT_SIZE; i++) begin
                rom[i] = TEXT[i];

        end
    end

    always_ff @(posedge clk) begin
        char_code <= char_code_nxt;
    end

    always_comb begin
        if (use_dynamic_text)
            char_code_nxt = text[char_xy][6:0];
        else
            char_code_nxt = rom[char_xy][6:0];
    end
    
endmodule
