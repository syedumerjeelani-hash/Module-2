module tb_sync_fifo;

    // Parameters matching the DUT
    parameter ADDR_WIDTH = 3;
    parameter DATA_WIDTH = 8;

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

    // Instantiate the DUT (Device Under Test)
    sync_fifo #(
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
        .count(count)
    );

    // Clock Generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 5.3 Style Self-Checking Tasks

    // General purpose checker for 1-bit flags (empty, full, valid, ready)
    task automatic check_flag(input logic actual, expected, string name);
        if (actual !== expected)
            $display("[FAIL] %s: expected=%0b actual=%0b at time=%0t", name, expected, actual, $time);
        else
            $display("[PASS] %s: value=%0b at time=%0t", name, actual, $time);
    endtask

    // Specialized checker for N-bit data buses (rd_data, count)
    task automatic check_data(input logic [DATA_WIDTH-1:0] actual, expected, string name);
        if (actual !== expected)
            $display("[FAIL] %s: expected=%0h actual=%0h at time=%0t", name, expected, actual, $time);
        else
            $display("[PASS] %s: value=%0h at time=%0t", name, actual, $time);
    endtask

    // Specialized checker for the count signal (ADDR_WIDTH+1 bits)
    task automatic check_count(input logic [ADDR_WIDTH:0] actual, expected, string name);
        if (actual !== expected)
            $display("[FAIL] %s: expected=%0d actual=%0d at time=%0t", name, expected, actual, $time);
        else
            $display("[PASS] %s: count=%0d at time=%0t", name, actual, $time);
    endtask


    // Stimulus and Verification Block
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sync_fifo);

        $display("=== STARTING SELF-CHECKING FIFO TESTBENCH ===");

        // 1. Reset Behavior Verification

        $display("\n--- TEST 1: Reset Behavior ---");
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        wr_data = 0;
        #15;
        rst_n   = 1;
        @(posedge clk);
        #1; // Delay slightly after edge to check settled combinational logic

        check_flag(empty, 1'b1, "Initial Empty Flag");
        check_flag(full,  1'b0, "Initial Full Flag");
        check_count(count, 4'd0, "Initial Count");

        // 2. Normal Write Operation

        $display("\n--- TEST 2: Normal Write Operation (Writing 11, 22) ---");
        wr_en = 1; wr_data = 8'h11; @(posedge clk);
        wr_en = 1; wr_data = 8'h22; @(posedge clk);
        wr_en = 0; #1;

        check_flag(empty, 1'b0, "Empty Flag after 2 writes");
        check_count(count, 4'd2, "Count after 2 writes");

        // 3. Normal Read Operation

        $display("\n--- TEST 3: Normal Read Operation (Reading 11) ---");
        rd_en = 1; @(posedge clk); #1;
        rd_en = 0; 

        check_flag(rd_valid, 1'b1, "rd_valid flag asserted");
        check_data(rd_data, 8'h11, "Read Data matches first written");
        check_count(count, 4'd1, "Count decremented to 1");


        // 4. Simultaneous Read/Write Behavior

        $display("\n--- TEST 4: Simultaneous Read and Write ---");
        // FIFO currently holds [22]. We will read 22 while writing 33.
        wr_en = 1; wr_data = 8'h33;
        rd_en = 1; 
        @(posedge clk); #1;
        wr_en = 0; rd_en = 0;

        check_flag(rd_valid, 1'b1, "rd_valid flag asserted during simultaneous op");
        check_data(rd_data, 8'h22, "Read Data is 22 during simultaneous op");
        check_count(count, 4'd1, "Count remains 1 (1 read, 1 written)");

        // 5. Full Condition & Overflow Protection

        $display("\n--- TEST 5: Full Condition and Overflow handling ---");
        // FIFO currently holds [33]. Count is 1.
        // We write 7 items to fill the remaining depth of 8.
        wr_en = 1;
        wr_data = 8'h44; @(posedge clk);
        wr_data = 8'h55; @(posedge clk);
        wr_data = 8'h66; @(posedge clk);
        wr_data = 8'h77; @(posedge clk);
        wr_data = 8'h88; @(posedge clk);
        wr_data = 8'h99; @(posedge clk);
        wr_data = 8'hAA; @(posedge clk);
        wr_en = 0; #1;

        check_flag(full, 1'b1, "Full Flag asserted");
        check_flag(wr_ready, 1'b0, "wr_ready deasserted");
        check_count(count, 4'd8, "Count reached max depth (8)");

        // Attempting to overflow the FIFO
        wr_en = 1; wr_data = 8'hFF; // Try to jam an FF into a full FIFO
        @(posedge clk); #1;
        wr_en = 0;

        check_count(count, 4'd8, "Count remained 8 after overflow attempt");

        // 6. Empty Condition & Underflow Protection

        $display("\n--- TEST 6: Empty Condition and Underflow handling ---");
        // FIFO currently holds: 33, 44, 55, 66, 77, 88, 99, AA.
        // We will read all 8 items, verifying the overflow attempt (FF) was ignored.
        rd_en = 1;
        
        @(posedge clk); #1; check_data(rd_data, 8'h33, "Verify read 1/8");
        @(posedge clk); #1; check_data(rd_data, 8'h44, "Verify read 2/8");
        @(posedge clk); #1; check_data(rd_data, 8'h55, "Verify read 3/8");
        @(posedge clk); #1; check_data(rd_data, 8'h66, "Verify read 4/8");
        @(posedge clk); #1; check_data(rd_data, 8'h77, "Verify read 5/8");
        @(posedge clk); #1; check_data(rd_data, 8'h88, "Verify read 6/8");
        @(posedge clk); #1; check_data(rd_data, 8'h99, "Verify read 7/8");
        @(posedge clk); #1; check_data(rd_data, 8'hAA, "Verify read 8/8 (Proves FF was dropped)");
        
        rd_en = 0; #1;

        check_flag(empty, 1'b1, "Empty Flag asserted");
        check_count(count, 4'd0, "Count reached 0");

        // Attempting to underflow the FIFO
        rd_en = 1;
        @(posedge clk); #1;
        rd_en = 0;

        check_flag(rd_valid, 1'b0, "rd_valid is 0 preventing empty read");

        $display("\n=== ALL SELF-CHECKS COMPLETE ===");
        $finish;
    end

endmodule