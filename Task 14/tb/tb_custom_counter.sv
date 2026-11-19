module tb_custom_counter;

    logic clk;
    logic rst_n;
    logic [2:0] q;

    // Instantiate the design under test
    custom_counter dut (
        .clk(clk),
        .rst_n(rst_n),
        .q(q)
    );

    // 10ns clock period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Array to hold the correct sequence order
    int expected_seq[5] = '{0, 1, 3, 4, 7};
    int step_idx = 0;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_custom_counter);
        
        $display(" STARTING CUSTOM SEQUENCE COUNTER TEST ");

        // 1. Initial Reset
        rst_n = 0;
        #12;
        rst_n = 1;
        $display("Reset released. Sequence starting...\n");
        
        step_idx = 1;
        // 2. Run for 3 full cycles (3 * 5 states = 15 checks)
        for (int i = 0; i < 15; i++) begin
            
            // Wait for the clock edge to update the register
            @(posedge clk);
            #1; // Slight delay to ensure outputs have settled
            
            $display("Time=%0t | Output Q = %d (Binary %03b)", $time, q, q);
            
            // Safety Check: Did it enter an illegal state?
            if (q == 3'd2 || q == 3'd5 || q == 3'd6) begin
                $display(">>> [FAIL] ILLEGAL STATE ENTERED: %d <<<", q);
                $finish;
            end

            // Verification Check: Does it match the expected sequence?
            if (q == expected_seq[step_idx]) begin
                $display("    -> [PASS] Matches expected state %d", expected_seq[step_idx]);
            end else begin
                $display("    -> [FAIL] Expected %d, but got %d", expected_seq[step_idx], q);
            end
            
            // Increment the index and wrap around at 5
            step_idx = (step_idx + 1) % 5;
            
            // Print a divider line when a full loop completes
            if (step_idx == 0) begin
                $display("                                     ");
                $display("Cycle completed. Wrapping back to 0.");
                $display("                                      ");
            end
        end

        $display("\n TEST COMPLETED SUCCESSFULLY FOR 3 FULL CYCLES ");
        $finish;
    end
endmodule