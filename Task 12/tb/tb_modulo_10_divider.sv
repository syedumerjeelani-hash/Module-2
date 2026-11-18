module tb_modulo_10_divider;

    logic clk;
    logic rst_n;
    logic [3:0] count;
    logic div_out;

    // Instantiate the behavioral module
    modulo_10_divider dut (
        .clk(clk),
        .rst_n(rst_n),
        .count(count),
        .div_out(div_out)
    );

    // Generate a clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_modulo_10_divider);

        $display("=== STARTING BEHAVIORAL MOD-10 TEST ===");

        // 1. Initial State & Reset
        rst_n = 0;
        #12; 
        rst_n = 1;

        // 2. Align to the first output pulse
        do begin
            @(posedge clk);
        end while (div_out == 1'b0);

        $display("Synchronized to first pulse at %0t ns", $time);
        $display("                                               ");

        // 3. Count edges between pulses
        for (int i = 1; i <= 3; i++) begin
            static int edges = 0;
            
            // Count every posedge clock until div_out pulses high again
            do begin
                @(posedge clk);
                edges++;
            end while (div_out == 1'b0);

            $display("Interval %0d | Input clocks elapsed: %0d", i, edges);
            
            if (edges == 10) begin
                $display("  -> [PASS] Ratio is exactly 10.");
            end else begin
                $display("  -> [FAIL] Expected 10, got %0d.", edges);
            end
            $display("                                               ");
        end

        $display("=== SIMULATION COMPLETE ===");
        $finish;
    end
endmodule