module Task_8 (
  input logic a,
  input logic b,
  input logic c,
  output logic F
);

mux_4x1 mux_inst (
  .sel({a, b}),
  .in({1'b1, 1'b0, 1'b1, c}), 
  .y(F)
);

endmodule