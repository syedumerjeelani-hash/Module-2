module tb;

    // Testbench signals
    logic [3:0] A;
    logic       p;
    
    // Variables for self-checking
    logic expected_p;
    int   error_count = 0;

    // Instantiate the Device Under Test (DUT)
    Parity dut (
        .A(A),
        .p(p)
    );

    initial begin

        $display("Starting Exhaustive Parity Generator Test...");
        $display("  A   | Expected | Actual | Result ");
        $display("--------------------------------------------");

        // Loop through all 16 possible 4-bit combinations (0 to 15)
        for (int i = 0; i < 16; i++) begin
            A = i;     
            #10; 

            // $countones returns the integer number of high bits. Modulo 2 (% 2) checks if it is odd.
            expected_p = ($countones(A) % 2);

            // Self-checking comparison
            if (p === expected_p) begin
                $display(" %4b |    %b     |   %b    |  PASS", A, expected_p, p);
            end else begin
                $display(" %4b |    %b     |   %b    |  FAIL", A, expected_p, p);
                error_count++;
            end
        end

        $display("                                      ");
        // Print final verdict
        if (error_count == 0)
            $display("[SUCCESS] All 16 combinations passed perfectly!");
        else
            $display("[FAILED]  Encountered %0d errors.", error_count);

        $finish;
    end
endmodule