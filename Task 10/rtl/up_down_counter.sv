module up_down_counter (
  input  logic clk, rst_n,
  input  logic up_down,
  output logic [3:0] y
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y <= 4'b0000;
    end
    else if (up_down == 1'b1) begin
      y <= y + 1;
    end
    else begin // up_down == 0
      y <= y - 1;
    end
  end
  
endmodule