module Leading_zero_count(
  input  logic [31:0] Data,
  output logic [5:0] Count
);

  always_comb begin
    if (Data == 32'b0) begin
      Count = 6'd32; // All bits are zero
    end else begin
      Count = 6'd0; // Initializing count to zero
      for (int i = 31; i >= 0; i--) begin
        if (Data[i] == 1'b0) begin
          Count++;
        end else begin
          break; // Stop counting when the first '1' is encountered
        end
      end
    end
  end
endmodule