module tb_Mealy_FSM;

    logic clk;
    logic rst_n;
    logic in;
    logic out;

    // Instantiate the Mealy FSM
    Mealy_FSM dut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .out(out)
    );

    // 10ns Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to apply a bit and display the result
    task apply_bit(input logic bit_val, input int expected_val);
        // Apply on the negative edge to ensure stable setup time
        @(negedge clk);
        in = bit_val;
        
        // Wait a tiny delay for combinational output logic to settle
        #1; 
        $display("Applied Bit: %b | Running Decimal Value: %0d | Divisible by 3? Output = %b", 
                 bit_val, expected_val, out);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Mealy_FSM);

        $display(" STARTING MODULO-3 MEALY FSM TEST \n");

        // SEQUENCE 1: Decimal 6 (Binary 110)
        // Progression: 1 -> 3 -> 6

        rst_n = 0; in = 0;
        #12; rst_n = 1;
        $display(" Testing Sequence 1: Binary 110 (Decimal 6) ");
        
        apply_bit(1'b1, 1); // 1 = not div by 3 (out=0)
        apply_bit(1'b1, 3); // 3 = div by 3 (out=1)
        apply_bit(1'b0, 6); // 6 = div by 3 (out=1)
        
        @(posedge clk); // Allow final state transition

        // SEQUENCE 2: Decimal 21 (Binary 10101)
        // Progression: 1 -> 2 -> 5 -> 10 -> 21

        $display("\n Testing Sequence 2: Binary 10101 (Decimal 21) ");
        // Reset the FSM for a fresh sequence
        rst_n = 0; 
        #10; 
        rst_n = 1;

        apply_bit(1'b1, 1);  // 1  (out=0)
        apply_bit(1'b0, 2);  // 2  (out=0)
        apply_bit(1'b1, 5);  // 5  (out=0)
        apply_bit(1'b0, 10); // 10 (out=0)
        apply_bit(1'b1, 21); // 21 (out=1)

        @(posedge clk);
        
        $display("\n SIMULATION COMPLETE ");
        $finish;
    end
endmodule