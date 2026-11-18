module tb_up_down_counter;

  logic clk, rst_n, up_down;
  logic [3:0] y;

  // Instantiate the module
  up_down_counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .up_down(up_down),
    .y(y)
  );

  // Generate a clock with a 10ns period (toggles every 5ns)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_up_down_counter);

    // Monitor automatically prints when variables change
    $monitor("Time=%3t ns | rst_n=%b | up_down=%b | Decimal: %2d | Binary: %4b", 
             $time, rst_n, up_down, y, y);

    $display("=== STARTING SIMULATION ===");

    // 1. Initial State & Reset
    rst_n = 0; 
    up_down = 1;
    #12; // Release reset slightly after a clock edge
    rst_n = 1;
    $display("--- Reset Released: Counting Up ---");

    // 2. Verify Count Up and Wraparound (15 -> 0)
    // Wait for 17 clock cycles (170 ns)
   #170;

    // 3. Verify Asynchronous Reset Mid-Count
    // At this point in time, wait 2ns so we are strictly between clock edges.
    #2;
    $display("\n--- ASSERTING ASYNC RESET MID-CLOCK ---");
    rst_n = 0; // The monitor will instantly print y=0 here, before the clock changes!
    
    #8; // Hold reset through the next clock edge
    rst_n = 1;
    $display("--- Reset Released --- \n");

    // 4. Verify Count Down and Wraparound (0 -> 15)
    $display("--- Counting Down ---");
    up_down = 0;
    #50; // Wait 5 clock cycles to see 0 wrap around to 15, 14, 13...

    $display("=== SIMULATION COMPLETE ===");
    $finish;
  end

endmodule