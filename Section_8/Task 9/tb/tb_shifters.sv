module tb_shifters;

    logic       s_A;
    logic [3:0] w_A;
    logic       k_A;
    logic [3:0] y_A;

    logic [1:0] sel_B;
    logic [3:0] w_B;
    logic [3:0] y_B;

    // Instantiate Part A: Simple Fixed Shifter
    simple_fixed_shifter dut_A (
        .k(k_A),
        .s(s_A),
        .w(w_A),
        .y(y_A)
    );

    // Instantiate Part B: Barrel Shifter
    barrel_shifter dut_B (
        .sel(sel_B),
        .w(w_B),
        .y(y_B)
    );

  
    logic [3:0] test_vectors [3];

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_shifters);
        sel_B = 2'b00;
        w_B = 4'b0000;
        // For at least 3 different values of W for testing
        test_vectors[0] = 4'b1101; 
        test_vectors[1] = 4'b0110; 
        test_vectors[2] = 4'b1000;

    
        // TESTING Single-Position Shift
        
        $display("=== PART A: Simple Fixed Shifter ===");
        $display(" s |   w  |   y  | k");
        $display("                    ");
        
        // Cover shift=0 and shift=1 across several values of W
        for (int shift_val = 0; shift_val < 2; shift_val++) begin
            for (int i = 0; i < 3; i++) begin
                s_A = shift_val;
                w_A = test_vectors[i];
                #10;
                $display(" %b | %b | %b | %b", s_A, w_A, y_A, k_A);
            end
            $display("                  ");
        end

        $display("\n");

        // TESTING Barrel Shifter
        
        $display("=== PART B: Barrel Shifter ===");
        $display(" sel |   w  |   y  ");
        $display("                    ");

        // Cover all 4 values of sel against at least 3 different values of W
        for (int s_val = 0; s_val < 4; s_val++) begin
            for (int i = 0; i < 3; i++) begin
                sel_B = s_val;
                w_B = test_vectors[i];
                #10;
                $display("  %2b | %b | %b", sel_B, w_B, y_B);
            end
            $display("                    ");
        end 

        $finish;
    end
endmodule