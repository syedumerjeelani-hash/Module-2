module reset_sync (
    input  logic clk,
    input  logic rst_n_async,
    output logic rst_n_sync
);
    // Internal signal for the first stage flip-flop
    logic ff1;

    // Both flip-flops are asynchronously cleared by the raw reset.
    // They are synchronously set to 1 by the clock.
    always_ff @(posedge clk or negedge rst_n_async) begin
        if (!rst_n_async) begin
            ff1        <= 1'b0; // Asserts immediately (async)
            rst_n_sync <= 1'b0; // Asserts immediately (async)
        end else begin
            ff1        <= 1'b1; // Captures '1' on first clock edge
            rst_n_sync <= ff1;  // Captures '1' on second clock edge
        end
    end

endmodule

/*  
If rst_n_async deasserts exactly at or dangerously close to the clock edge, it violates this recovery 
time. The downstream flip-flop gets confused about whether it is supposed to stay in reset or start 
capturing data. As a result, its output goes metastable (bouncing between 0 and 1, or settling at an 
intermediate voltage, represented by XXX). If different parts of a large chip exit reset on different 
clock cycles due to this metastability, the system state will be permanently corrupted.

Asynchronous Assertion: When rst_n_async drops (1 -> 0), the asynchronous clear instantly zeroes 
both ff1 and rst_n_sync. The entire chip resets immediately. When rst_n_async 
deasserts (0 -> 1) dangerously close to clock edge 2, it violates the recovery time of ff1. 
ff1 goes metastable (XXX). Even though ff1 is metastable, rst_n_sync is safe because it is simply 
capturing the previous value of ff1 (which was solidly 0). By the time clock edge 3 arrives, ff1 has had
an entire clock cycle to resolve its metastability and safely settle at 1 (since its D-input is tied to 
High). On clock edge 3, rst_n_sync samples the now-stable ff1. rst_n_sync cleanly transitions 
from 0 -> 1 perfectly aligned with the clock edge.
*/