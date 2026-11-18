module tb_lzc;

    // Testbench signals
    logic [31:0] in;
    logic [5:0]  out_linear; 
    logic [5:0]  out_tree;

    // 1. Instantiating...
    Leading_zero_count dut_linear (
        .Data(in),
        .Count(out_linear)
    );

    // 2. Instantiating Tree Version
    leading_zero_tree dut_tree (
        .data_in(in),
        .count(out_tree)
    );

    // Task to apply a test vector and print the results to the console
    task apply_test(input logic [31:0] test_val, string msg);
        in = test_val;
        #10; // Wait 10 time units to allow combinational logic to settle
        $display("Time=%0t | %s | Input: 32'h%08h | Linear LZC: %0d | Tree LZC: %0d", 
                 $time, msg, in, out_linear, out_tree);
    endtask

    initial begin
      
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_lzc);
        
        $display("=== STARTING LZC TESTBENCH ===\n");
        
        // 1. Directed Edge Cases

        $display("--- Directed Edge Cases ---");
        apply_test(32'h00000000, "All Zeros               ");
        apply_test(32'h00000001, "Single Bit Set (Pos 0)  ");
        apply_test(32'h00008000, "Single Bit Set (Pos 15) ");
        apply_test(32'h80000000, "Single Bit Set (Pos 31) ");
        apply_test(32'hFFFFFFFF, "All Ones                ");

        // 2. Random Vector Sweep

        $display("\n--- Random Vector Sweep (50 Iterations) ---");
        for (int i = 1; i <= 50; i++) begin
            // Concatenate two 16-bit $random calls for a full 32-bit random vector
            static logic [31:0] rand_val = {$random, $random}; 
            
            // Randomly force a few vectors to exactly 0 to test the edge case repeatedly
            if (i % 15 == 0) rand_val = 32'h00000000;
            
            apply_test(rand_val, $sformatf("Random Sweep %02d       ", i));
        end

        $display("\n=== SIMULATION COMPLETE ===");
        $finish;
    end

endmodule