module Parity(
    input logic [3:0] A,
    output logic p
);
    assign p = ^A; // XOR reduction operator for parity
endmodule