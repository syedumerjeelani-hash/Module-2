module FA(
    input logic a, b, cin,
    output logic sum, cout
);
    logic sum_ha1, cout_ha1;
    logic cout_ha2;
    
    // First Half Adder (Instantiating the assign version)
    HA HA1 (
        .A(a), 
        .B(b),
        .Sum1(sum_ha1), 
        .Cout1(cout_ha1)
    );
    
    // Second Half Adder
    HA HA2 (
        .A(sum_ha1), 
        .B(cin),
        .Sum1(sum), 
        .Cout1(cout_ha2)
    );
    
    // OR gate for final Carry Out
    assign cout = cout_ha1 | cout_ha2;
endmodule