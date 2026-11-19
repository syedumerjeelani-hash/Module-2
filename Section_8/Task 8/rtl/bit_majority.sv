module bit_majority (
    input logic a,
    input logic b,
    input logic c,
    output logic F
);
logic w1, w2;

always_comb begin
  if(b == 0)begin
    w1 = 1'b0;
    w2 = c;
  end
  else begin
    w1 = c;
    w2 = 1'b1;
  end
end
assign F = a ? w2 : w1;
endmodule
