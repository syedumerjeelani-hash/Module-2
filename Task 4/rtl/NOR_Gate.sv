module NOR_Gate (input logic A, B, C, D, output logic y, f);
    
    assign f = (B | C | D) & (~A | B | C) & (~A | D);

    assign y = ~( ~(B | C | D) | ~( ~(A | A) | B | C) | ~( ~(A | A) | D) );

endmodule