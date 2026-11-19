module Mealy_FSM ( 
    input  logic clk, 
    input  logic rst_n, 
    input  logic in,
    output logic out 

);
/* when serial binary input gets divided by 3 then, we can have 3 states, R_0, R_1, R_2 where
 R_0 means remainder is 0, R_1 means remainder is 1, R_2 means remainder is 2 
 */
    typedef enum logic [1:0] {R_0, R_1, R_2} state_t; 
    state_t current_state, next_state; 
  
    // Block 1: State Register (Sequential)
    always_ff @(posedge clk or negedge rst_n) begin 
        if (!rst_n) 
            current_state <= R_0; 
        else 
            current_state <= next_state;
    end 
  
    // Block 2: Next-State Logic (Combinational)
    always_comb begin 
        case (current_state) 
            R_0:  next_state = in ? R_1 : R_0; 
            R_1:  next_state = in ? R_0 : R_2; 
            R_2:  next_state = in ? R_2 : R_1;
            default: next_state = R_0; 
        endcase 
    end 
  
    //  Block 3: Output Logic (Combinational, Mealy) 
    always_comb begin 
        out = 1'b0;
        
        case (current_state) 
            R_0: out = in ? 1'b0 : 1'b1;
            R_1: out = in ? 1'b1 : 1'b0;
            R_2: out = in ? 1'b0 : 1'b0;
        endcase 
    end 
endmodule