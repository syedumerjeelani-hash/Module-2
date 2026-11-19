module custom_counter (
    input  logic clk,
    input  logic rst_n,
    output logic [2:0] q
);
    logic t2, t1, t0;

    // Excitation logic derived from K-Maps
    assign t2 = q[1];
    assign t1 = q[2] | q[0];
    assign t0 = q[1] | ~q[0];

    // Instantiate 3 T flip-flops
    t_ff ff2 (.clk(clk), .rst_n(rst_n), .t(t2), .q(q[2]));
    t_ff ff1 (.clk(clk), .rst_n(rst_n), .t(t1), .q(q[1]));
    t_ff ff0 (.clk(clk), .rst_n(rst_n), .t(t0), .q(q[0]));

endmodule