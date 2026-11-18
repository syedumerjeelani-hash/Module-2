module MIMO_FSM ( 
    input  logic clk, 
    input  logic rst_n, 
    input  logic start, 
    input  logic cancel,
    output logic busy,
    output logic done
); 
    typedef enum logic [1:0] {IDLE, BUSY_1, BUSY_2, DONE} state_t; 
    state_t current_state, next_state; 
  
    // Block 1: State Register (Sequential)
    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            current_state <= IDLE; 
        else 
            current_state <= next_state;
    end 
  
    // Block 2: Next-State Logic (Combinational)
    always_comb begin 
        case (current_state) 
            IDLE:    next_state = start ? BUSY_1 : IDLE; 
            BUSY_1:  next_state = cancel ? IDLE : BUSY_2; 
            BUSY_2:  next_state = cancel ? IDLE : DONE; 
            DONE:    next_state = IDLE; // an unconditional return to IDLE
            default: next_state = IDLE; 
        endcase 
    end 
  
    //  Block 3: Output Logic (Combinational, Moore) 
    always_comb begin 
        busy = 1'b0;
        done = 1'b0;
        
        case (current_state) 
            IDLE: begin
                busy = 1'b0;
                done = 1'b0;
            end
            BUSY_1: begin
                busy = 1'b1;
                done = 1'b0;
            end
            BUSY_2: begin
                busy = 1'b1; // Stays busy during the second processing cycle
                done = 1'b0;
            end
            DONE: begin
                busy = 1'b0;
                done = 1'b1; // Asserts done for exactly one cycle
            end
        endcase 
    end 
endmodule