module tb_MIMO_FSM;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic start;
    logic cancel;
    logic busy;
    logic done;

    // Instantiate the FSM (Device Under Test)
    MIMO_FSM dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .cancel(cancel),
        .busy(busy),
        .done(done)
    );

    // Generate a 10ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus and verification block
    initial begin
        // Setup waveform dumping for EDA Playground
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_MIMO_FSM);

        // Monitor prints a line to the console anytime a signal changes
        $monitor("Time=%0t | start=%b cancel=%b | FSM Output: busy=%b done=%b", 
                 $time, start, cancel, busy, done);

        $display("=== STARTING FSM TEST ===");

        // 0. Initial State & Reset

        rst_n = 0;
        start = 0;
        cancel = 0;
        #12; 
        rst_n = 1; // Release reset
        

        // CASE 1: Normal Full Process (No Cancel)

        $display("\n--- CASE 1: Normal Process (IDLE -> BUSY_1 -> BUSY_2 -> DONE -> IDLE) ---");
        @(posedge clk); 
        start = 1;      // Send Start request
        @(posedge clk); 
        start = 0;      // Drop Start request
        
        // Wait enough clock cycles to watch it complete the sequence
        repeat(4) @(posedge clk);

        // CASE 2: Cancel during BUSY_1

        $display("\n--- CASE 2: Cancel during BUSY_1 (Should Abort) ---");
        @(posedge clk); 
        start = 1;      // Send Start request
        
        @(posedge clk); 
        start = 0;
        cancel = 1;     // FSM is now in BUSY_1. Assert cancel!
        
        @(posedge clk); 
        cancel = 0;     // Drop cancel. FSM should be safely back in IDLE.
        
        repeat(2) @(posedge clk);

        // CASE 3: Cancel during BUSY_2

        $display("\n--- CASE 3: Cancel during BUSY_2 (Should Abort) ---");
        @(posedge clk); 
        start = 1;      // Send Start request
        
        @(posedge clk); 
        start = 0;      // FSM is now in BUSY_1. Let it continue.
        
        @(posedge clk); 
        cancel = 1;     // FSM is now in BUSY_2. Assert cancel!
        
        @(posedge clk); 
        cancel = 0;     // Drop cancel. FSM should be safely back in IDLE.
        
        repeat(2) @(posedge clk);


        $display("\n=== SIMULATION COMPLETE ===");
        $finish;
    end

endmodule