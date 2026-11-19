module tb;
logic a, b, c;
    logic F;
    logic expected_F;
    int   error_count = 0;

    // Instantiating DUT (Device Under Test)
    Task_8 dut (
        .a(a),
        .b(b),
        .c(c),
        .F(F)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        $display("Testing F = Sum m(1,2,3,6,7) implemented via 4x1 MUX");
        $display("                                                    ");
        $display(" Minterm | a b c | Expected | Actual | Result ");
        $display("                                                    ");

        // Exhaustively loop through all 8 minterm combinations (0 to 7)
        for (int i = 0; i < 8; i++) begin
            {a, b, c} = i;
            #10; // Wait for combinational logic to propagate
            
            // Determine expected value based on the minterm list
            if (i == 1 || i == 2 || i == 3 || i == 6 || i == 7)
                expected_F = 1'b1;
            else
                expected_F = 1'b0;

            // Self-checking condition
            if (F === expected_F) begin
                $display("    m%0d   | %b %b %b |    %b     |   %b    |  PASS", 
                         i, a, b, c, expected_F, F);
            end else begin
                $display("    m%0d   | %b %b %b |    %b     |   %b    |  FAIL", 
                         i, a, b, c, expected_F, F);
                error_count++;
            end
        end

        $display("                                             ");
        if (error_count == 0)
            $display("All 8 minterms evaluated correctly!");
        else
            $display("Found %0d errors in logic.", error_count);

        $finish;
    end

endmodule