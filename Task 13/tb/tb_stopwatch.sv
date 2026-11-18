module tb_stopwatch;

    logic clk;
    logic clr;
    logic [3:0] min;
    logic [3:0] sec_tens;
    logic [3:0] sec_ones;
    logic [3:0] tenths;

    // 1 "decisecond" = 5 clock cycles
    stopwatch #( .TICKS_PER_DECISEC(5) ) dut (
        .clk(clk),
        .clr(clr),
        .min(min),
        .sec_tens(sec_tens),
        .sec_ones(sec_ones),
        .tenths(tenths)
    );

    // 10ns clock period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_stopwatch);

        // Track outputs cleanly on screen
        $monitor("Time=%0t | clr=%b | Display -> %0d:%0d%0d.%0d", 
                 $time, clr, min, sec_tens, sec_ones, tenths);

        $display("=== STARTING STOPWATCH SIMULATION ===");
        
        // 1. Assert Clear
        clr = 1;
        #15;
        clr = 0; // Release clear, stopwatch begins counting

    
        // TEST 1: Tenths Rollover Boundary (0:00:9 -> 0:01:0)
      
        // With 5 cycles/decisec, 1.0 second = 50 cycles = 500 ns
        // Wait 490 ns to approach the 0:00:9 mark
        #480; 
        $display("\n--- Approaching Tenths Rollover ---");
        #40; // Let it cross over to 1.0s cleanly

        
        // TEST 2: Minute Rollover Boundary (0:59:9 -> 1:00:0)
        
        // 1 minute = 60 seconds = 600 deciseconds = 3000 clock cycles = 30,000 ns
        // We've already elapsed ~500 ns. Let's wait another 29,400 ns to reach ~0:59:8
        #29350;
        $display("\n--- Approaching 1-Minute Rollover ---");
        
        // Watch it tick from 0:59:8 -> 0:59:9 -> 1:00:0 -> 1:00:1
        #200; 

        // TEST 3: Verify Clear functions mid-count
       
        $display("\n--- Asserting Clear Mid-Count ---");
        clr = 1;
        #20;
        clr = 0;
        #50;

        $display("=== SIMULATION COMPLETE ===");
        $finish;
    end
endmodule