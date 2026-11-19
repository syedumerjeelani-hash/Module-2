module tb_reset_sync;

    logic clk;
    logic rst_n_async;
    logic rst_n_sync;

    // Instantiate the DUT
    reset_sync dut (
        .clk(clk),
        .rst_n_async(rst_n_async),
        .rst_n_sync(rst_n_sync)
    );

    // Generate a 10ns clock (Rising edges at 5, 15, 25, 35, 45...)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        // Setup waveform dumping for EDA Playground / EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_reset_sync);

        $display("Time | rst_n_async | rst_n_sync | Note");
        $display("                                                ");
        
        // Monitor tracks changes automatically
        $monitor("%4t |      %b      |      %b     |", $time, rst_n_async, rst_n_sync);

        // --- TEST 1: Safe Asynchronous Assert & Safe Deassert ---
        rst_n_async = 1;
        
        #12; // t=12 (Mid-cycle). 
        $display("     |             |            | -> Async Assert (Mid-cycle)");
        rst_n_async = 0; 
        
        #11; // t=23 (2ns before the clock edge at 25). 
        $display("     |             |            | -> Safe Deassert (Before edge)");
        rst_n_async = 1; 

        // Wait for synchronization
        #25; 

        // --- TEST 2: Dangerous Deassert EXACTLY on a Clock Edge ---
        // t=48 (Mid-cycle).
        $display("     |             |            | -> Async Assert (Mid-cycle)");
        rst_n_async = 0; 

        #17; // t=65 (EXACTLY on a clock rising edge).
        $display("     |             |            | -> Dangerous Deassert (ON edge!)");
        rst_n_async = 1; 

        #40;
        $display("                                                ");
        $display("Simulation Complete. Check the waveform to see clean alignment.");
        $finish;
    end
endmodule