module stopwatch #(
    // Set to 10,000,000 for a 100MHz clock. 
    parameter TICKS_PER_DECISEC = 10_000_000 
)(
    input  logic clk,
    input  logic clr,
    output logic [3:0] min,
    output logic [3:0] sec_tens,
    output logic [3:0] sec_ones,
    output logic [3:0] tenths
);
    logic [31:0] clk_count;
    logic tick_0_1s;


    // A. 0.1-Second Tick Generator
        always_ff @(posedge clk) begin
        if (clr) begin
            clk_count <= 0;
            tick_0_1s <= 1'b0;
        end else begin
            if (clk_count == TICKS_PER_DECISEC - 1) begin
                clk_count <= 0;
                tick_0_1s <= 1'b1; // Generate 1-cycle pulse
            end else begin
                clk_count <= clk_count + 1'b1;
                tick_0_1s <= 1'b0;
            end
        end
    end

    // B. Cascaded Counters
    
    logic tc_tenths;
    logic tc_sec_ones;
    logic tc_sec_tens;
    logic tc_min;

    // Stage 1: Tenths (Modulo-10, 0 to 9)
    digit_counter #(.MAX(9), .BITS(4)) count_tenths (
        .clk(clk), .clr(clr), .en(tick_0_1s), 
        .val(tenths), .tc(tc_tenths)
    );

    // Stage 2: Seconds - Ones (Modulo-10, 0 to 9)
    digit_counter #(.MAX(9), .BITS(4)) count_sec_ones (
        .clk(clk), .clr(clr), .en(tc_tenths), 
        .val(sec_ones), .tc(tc_sec_ones)
    );

    // Stage 3: Seconds - Tens (Modulo-6, 0 to 5)
    digit_counter #(.MAX(5), .BITS(4)) count_sec_tens (
        .clk(clk), .clr(clr), .en(tc_sec_ones), 
        .val(sec_tens), .tc(tc_sec_tens)
    );

    // Stage 4: Minutes (Modulo-10, 0 to 9)
    digit_counter #(.MAX(9), .BITS(4)) count_minutes (
        .clk(clk), .clr(clr), .en(tc_sec_tens), 
        .val(min), .tc(tc_min)
    );

endmodule