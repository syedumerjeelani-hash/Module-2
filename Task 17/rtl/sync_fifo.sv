module sync_fifo #(
    parameter ADDR_WIDTH = 3,                  // Depth = 2^3 = 8
    parameter DATA_WIDTH = 8
)(
    input  logic rst_n,                        // Active low reset
    input  logic clk,                          // Clock
    input  logic wr_en,                        // Write enable
    input  logic rd_en,                        // Read enable
    input  logic [DATA_WIDTH-1:0] wr_data,     // Data written into FIFO
    
    output logic [DATA_WIDTH-1:0] rd_data,     // Data read from FIFO
    output logic empty,                        // FIFO is empty when high
    output logic full,                         // FIFO is full when high
    output logic wr_ready,                     // High when FIFO can accept data
    output logic rd_valid,                     // High when rd_data is valid
    output logic [ADDR_WIDTH:0] count          // Number of elements in FIFO
);

    // Calculate depth dynamically based on ADDR_WIDTH
    localparam DEPTH = 1 << ADDR_WIDTH; 

    // Pointers are ADDR_WIDTH + 1 bits wide (e.g., 4 bits for Depth 8)
    // The extra MSB tracks how many times the pointer has wrapped around.
    logic [ADDR_WIDTH:0] wptr; 
    logic [ADDR_WIDTH:0] rptr; 
    
    // Memory array (addressed using only the lower bits of the pointers)
    logic [DATA_WIDTH-1:0] fifo [0:DEPTH-1];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr     <= 0;
            rptr     <= 0;
            rd_valid <= 1'b0;
        end else begin
            
            // --- Write Operation ---
            if (wr_en && !full) begin
                // Use only the lower ADDR_WIDTH bits for the actual memory address
                fifo[wptr[ADDR_WIDTH-1:0]] <= wr_data;
                wptr <= wptr + 1'b1;
            end
            
            // --- Read Operation ---
            if (rd_en && !empty) begin
                rd_data  <= fifo[rptr[ADDR_WIDTH-1:0]];
                rptr     <= rptr + 1'b1;
                rd_valid <= 1'b1; // Signals that output data is valid this cycle
            end else begin
                rd_valid <= 1'b0;
            end
            
        end
    end

    // --- Status & Flow Control Logic (Combinational) ---
    
    // Empty: Both pointers are exactly identical
    assign empty = (wptr == rptr);
    
    // Full: The MSBs are different (one wrapped, one didn't), but the lower bits match
    assign full = (wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH]) && 
                  (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]);
                  
    // Count: Simply subtract read pointer from write pointer 
    // (Binary math handles the wrapping naturally)
    assign count = wptr - rptr;
    
    // Flow control mappings
    assign wr_ready = !full;

endmodule