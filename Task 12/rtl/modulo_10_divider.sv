module modulo_10_divider (
    input  logic clk,
    input  logic rst_n,
    output logic [3:0] count,
    output logic div_out
);
    // Internal wires for the T inputs
    logic t0, t1, t2, t3;

    // Derived Boolean equations for counting 0 to 9 synchronously
    assign t0 = 1'b1;
    assign t1 = count[0] & ~count[3];
    assign t2 = count[0] & count[1];
    assign t3 = (count[0] & count[1] & count[2]) | (count[0] & count[3]);

    // Instantiate four T Flip-Flops for the 4-bit counter
    t_ff ff0 (
        .clk(clk), 
        .rst_n(rst_n), 
        .t(t0), 
        .q(count[0])
    );
    
    t_ff ff1 (
        .clk(clk), 
        .rst_n(rst_n), 
        .t(t1), 
        .q(count[1])
    );
    
    t_ff ff2 (
        .clk(clk), 
        .rst_n(rst_n), 
        .t(t2), 
        .q(count[2])
    );
    
    t_ff ff3 (
        .clk(clk), 
        .rst_n(rst_n), 
        .t(t3), 
        .q(count[3])
    );

    // Output pulse that goes high exactly once every 10 clocks
    assign div_out = (count == 4'd9);

endmodule