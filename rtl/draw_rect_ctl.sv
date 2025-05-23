module draw_rect_ctl (
        input  logic        clk,        
        input  logic        rst,
        input  logic        mouse_left,
        input  logic [11:0] mouse_xpos,
        input  logic [11:0] mouse_ypos,
        output logic [11:0] xpos,
        output logic [11:0] ypos
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    logic [11:0] xpos_nxt;
    logic [11:0] ypos_nxt;
    logic [8:0] rapidity;
    logic [8:0] rapidity_nxt;
    
    localparam SPEED = 2;
    localparam JUMP_RATE = 6;
    localparam HEIGHT = 64;

    typedef enum bit [2:0] {
        IDLE = 3'b000,
        DOWN = 3'b001,
        JUMP = 3'b010,
        UP = 3'b011,
        STOP = 3'b100,
        RST = 3'b101
    } state_t;

    state_t state, next_state;

      always_ff @(posedge clk) begin : state_ff_blk
        if (rst) begin
            state <= IDLE;
            xpos  <= mouse_xpos;
            ypos  <= mouse_ypos;
            rapidity <= 0;

        end else begin
            state  <= next_state;
            xpos   <= xpos_nxt;
            ypos   <= ypos_nxt;
            rapidity <= rapidity_nxt;
        end
      end
    
    always_comb begin : state_nxt_blk
        case (state)
            IDLE:       next_state = mouse_left && mouse_ypos <= VER_PIXELS - HEIGHT ? DOWN : IDLE;
            DOWN:       next_state = ypos >= VER_PIXELS - HEIGHT - rapidity - SPEED ? JUMP : DOWN;
            JUMP:       next_state = rapidity <= JUMP_RATE ? STOP : UP;
            UP:         next_state = rapidity <= SPEED ? DOWN : UP;
            STOP:       next_state = mouse_left ? RST : STOP;
            RST:        next_state = !mouse_left ? IDLE : RST;
            default:    next_state = IDLE;
        endcase
    end

    always_comb begin : next_state_comb_blk 
        
        case(state)
            IDLE: begin
                xpos_nxt = mouse_xpos;
                ypos_nxt = mouse_ypos;
                rapidity_nxt = 0;
            end

            DOWN: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + rapidity >= VER_PIXELS - HEIGHT ? VER_PIXELS - HEIGHT : ypos + rapidity;
                rapidity_nxt = rapidity + SPEED;
            end

            JUMP: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                rapidity_nxt = rapidity - JUMP_RATE;
            end

            UP: begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - rapidity;
                rapidity_nxt = rapidity - SPEED;
            end

            STOP, RST: begin
                xpos_nxt = xpos;
                ypos_nxt = VER_PIXELS - HEIGHT - 1;
                rapidity_nxt = 0;
            end

            default: begin
                xpos_nxt = mouse_xpos;
                ypos_nxt = mouse_ypos;
                rapidity_nxt = 0;
            end
        endcase
    end

endmodule
