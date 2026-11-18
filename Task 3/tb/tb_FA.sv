module tb_FA;
    logic a, b, cin;
    logic sum_fa, cout_fa;

    // Instantiate the module
    FA inst (.a(a), .b(b), .cin(cin), .sum(sum_fa), .cout(cout_fa));

    initial begin
        // Full Adder Verification
        $display("\n Full Adder Verification ");
        $display(" a b cin | Sum Cout");

        // Case 0: 0 0 0
        a = 0; b = 0; cin = 0; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 1: 0 0 1
        a = 0; b = 0; cin = 1; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 2: 0 1 0
        a = 0; b = 1; cin = 0; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 3: 0 1 1
        a = 0; b = 1; cin = 1; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 4: 1 0 0
        a = 1; b = 0; cin = 0; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 5: 1 0 1
        a = 1; b = 0; cin = 1; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 6: 1 1 0
        a = 1; b = 1; cin = 0; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        // Case 7: 1 1 1
        a = 1; b = 1; cin = 1; #10;
        $display(" %b %b  %b  |  %b   %b", a, b, cin, sum_fa, cout_fa);

        $finish;
    end
endmodule