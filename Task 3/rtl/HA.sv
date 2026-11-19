module HA(
    input logic A, B, C, D, Cin, // Note: Cin is unused because this is a Half Adder, but kept to match your TB
    output logic Sum1, Sum2, Cout1, Cout2
);

    // 1st Half Adder (Assign)
    assign Sum1 = A ^ B;
    assign Cout1 = A & B;

    // 2nd Half Adder (If-Else)
    always_comb begin
        if(C == 1'b0 && D == 1'b0) begin
            Sum2 = 1'b0;
            Cout2 = 1'b0;
        end else if(C == 1'b0 && D == 1'b1) begin
            Sum2 = 1'b1;
            Cout2 = 1'b0;
        end else if(C == 1'b1 && D == 1'b0) begin
            Sum2 = 1'b1;
            Cout2 = 1'b0;
        end else if(C == 1'b1 && D == 1'b1) begin
            Sum2 = 1'b0;
            Cout2 = 1'b1;
        end else begin 
            // to prevent the simulator from inferring latches when inputs are X or Z
            Sum2 = 1'bx;
            Cout2 = 1'bx;
        end
    end
endmodule


/* 

Synthesis tools do not convert hardware description code strictly line by line. They check for the 
boolean logic implemented by assign or if-else statement by checking their equivalent truth table.
Since, both assign and always_comb implement same boolean logic for this module so, the synthesizer
outputs the identical hardware. 

*/