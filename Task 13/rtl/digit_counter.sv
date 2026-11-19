module digit_counter #(
    parameter MAX = 9,       // Roll-over value
    parameter BITS = 4       // Bit width required
)(
    input  logic clk,
    input  logic clr,        // Synchronous clear
    input  logic en,         // Enable from previous stage
    output logic [BITS-1:0] val,
    output logic tc          // Terminal Count pulse
);
    // Asserts TC high for 1 clock cycle when at MAX and enabled
    assign tc = en && (val == MAX);

    always_ff @(posedge clk) begin
        if (clr) begin
            val <= 0;
        end else if (en) begin
            if (val == MAX) 
                val <= 0;
            else            
                val <= val + 1'b1;
        end
    end
endmodule