module t_ff (
    input  logic clk,
    input  logic rst_n,
    input  logic t,
    output logic q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            q <= 1'b0;
        else if (t) 
            q <= ~q;
    end
endmodule