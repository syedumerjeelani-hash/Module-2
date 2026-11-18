module simple_fixed_shifter(
input logic s,
input logic [3:0]w,
output logic [3:0]y,
output logic k
);

//Assigning output bits according to shifter

assign y[3] = s ? 1'b0 : w[3];

assign y[2] = s ? w[3] : w[2];

assign y[1] = s ? w[2] : w[1];

assign y[0] = s ? w[1] : w[0];

// For k:
assign k = s ? w[0] : 1'b0;

endmodule