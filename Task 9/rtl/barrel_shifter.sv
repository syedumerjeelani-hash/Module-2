module barrel_shifter (
input logic [1:0]sel,
input logic [3:0]w,
output logic [3:0]y
);


    always_comb begin 
        unique case (sel == 2'b00)

            2'b00: y = w;

            2'b01: begin
             y[3] = w[0];
             y[2] = w[3];
             y[1] = w[2];
             y[0] = w[1];
            end

            2'b10: begin
             y[3] = w[1];
             y[2] = w[0];
             y[1] = w[3];
             y[0] = w[2];
            end 

            2'b11: begin
             y[3] = w[2];
             y[2] = w[1];
             y[1] = w[0];
             y[0] = w[3];
            end
        
        endcase 
    end 
endmodule

/* When we use a plain case, the synthesizer and simulator assume that the conditions might have
   overlapping priorities or that some states might be intentionally left undefined. If all possible 
   input combinations aren't explicitly covered, the synthesizer might infer unwanted memory elements 
   (latches) to hold the previous value.
   
   By adding the unique keyword, we can have extra guarantees:

   1-)The simulator guarantees that exactly one case condition will match at any given time 
   (no overlapping conditions, and no missing conditions). If the simulator encounters an input that 
   matches zero cases or multiple cases, it will immediately throw a run-time error/warning. This helps 
   you catch bugs during testing before they ever reach hardware.
   
   2-) The synthesizer guarantees that all cases are mutually exclusive and fully exhaust the possible 
   states. The synthesizer can safely skip generating priority-encoding logic (which checks cases 
   sequentially) and skip generating latches. Instead, it optimizes the circuit into pure, fast, parallel
   multiplexers, saving area and reducing delay.
*/