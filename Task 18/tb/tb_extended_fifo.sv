module tb_extended_fifo;
T
    parameter ADDR_WIDTH = 3;
    parameter DATA_WIDTH = 8;
    localparam DEPTH = 1 << ADDR_WIDTH; // Depth = 8

    // Testbench Signals
    logic rst_n;
    logic clk;
    logic wr_en;
    logic rd_en;
    logic [DATA_WIDTH-1:0] wr_data;
    
    logic [DATA_WIDTH-1:0] rd_data;
    logic empty;
    logic full;
    logic wr_ready;
    logic rd_valid;
    logic [ADDR_WIDTH:0] count;
    logic almost_empty;
    logic almost_full;

    // Instantiate the DUT (Device Under Test)
    fifo_extension #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .rst_n(rst_n),
        .clk(clk),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .empty(empty),
        .full(full),
        .wr_ready(wr_ready),
        .rd_valid(rd_valid),
        .count(count),
        .almost_empty(almost_empty),
        .almost_full(almost_full)
    );

    // Clock Generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Self-Checking Tasks

    task automatic check_flag(input logic actual, expected, string name);
        if (actual !== expected)
            $display("[FAIL] %s: expected=%0b actual=%0b at time=%0t", name, expected, actual, $time);
        else
            $display("[PASS] %s: value=%0b at time=%0t", name, actual, $time);
    endtask

    task automatic check_count(input logic [ADDR_WIDTH:0] actual, expected, string name);
        if (actual !== expected)
            $display("[FAIL] %s: expected=%0d actual=%0d at time=%0t", name, expected, actual, $time);
        else
            $display("[PASS] %s: count=%0d at time=%0t", name, actual, $time);
    endtask

    // Stimulus and Verification Block

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_extended_fifo);

        $display("=== STARTING EXTENDED FIFO TESTBENCH ===");

        // 1. Reset
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;
        #15;
        rst_n   = 1;
        @(posedge clk);
        #1; 

        // TEST 1: Drive to Depth - 1 and check almost_full

        $display("\n--- TEST 1: Writing to DEPTH-1 (7 items) ---");
        for (int i = 1; i <= (DEPTH - 1); i++) begin
            wr_en = 1;
            wr_data = i * 8'h10; 
            @(posedge clk);
        end
        wr_en = 0;
        #1; // Allow combinational flags to settle

        check_count(count, 4'd7, "Count at DEPTH - 1");
        check_flag(almost_full, 1'b1, "almost_full is ASSERTED");
        check_flag(full, 1'b0, "full is NOT asserted");

        // TEST 2: Drive to Full and ensure almost_full deasserts

        $display("\n--- TEST 2: Writing 1 more item to reach FULL (8 items) ---");
        wr_en = 1;
        wr_data = 8'h80;
        @(posedge clk);
        wr_en = 0;
        #1;

        check_count(count, 4'd8, "Count at DEPTH");
        check_flag(almost_full, 1'b0, "almost_full is DEASSERTED");
        check_flag(full, 1'b1, "full is ASSERTED");

        // TEST 3: Drive down to 1 item and check almost_empty

        $display("\n--- TEST 3: Reading down to 1 item left ---");
        // We have 8 items. To get to 1, we read 7 items.
        for (int i = 1; i <= (DEPTH - 1); i++) begin
            rd_en = 1;
            @(posedge clk);
        end
        rd_en = 0;
        #1;

        check_count(count, 4'd1, "Count at exactly 1 item");
        check_flag(almost_empty, 1'b1, "almost_empty is ASSERTED");
        check_flag(empty, 1'b0, "empty is NOT asserted");

        // TEST 4: Drive to Empty and ensure almost_empty deasserts
        
        $display("\n--- TEST 4: Reading final item to reach EMPTY (0 items) ---");
        rd_en = 1;
        @(posedge clk);
        rd_en = 0;
        #1;

        check_count(count, 4'd0, "Count at 0");
        check_flag(almost_empty, 1'b0, "almost_empty is DEASSERTED");
        check_flag(empty, 1'b1, "empty is ASSERTED");

        $display("\n=== ALL EXTENDED FIFO CHECKS COMPLETE ===");
        $finish;
    end

endmodule