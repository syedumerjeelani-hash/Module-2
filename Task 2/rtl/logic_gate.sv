// Code your design here
module logic_gate ( 
    input  logic a, b, 
    output logic y,x,z 
); 
    assign y = a & b; //and
  	assign x = a | b; //or
  	assign z = a ^ b; //xor
  
endmodule