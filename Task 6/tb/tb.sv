module tb; logic [2:0] Sel; logic en; logic [7:0] Y;
   
    Decoder dut (
        .Sel(Sel),
        .en(en),
        .Y(Y)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Test all combinations of Sel and en
        for (int i = 0; i < 8; i++) begin
            Sel = i[2:0]; // Assign the 3-bit value to Sel
            en = 1;       // Enable the decoder
            #5;           // Wait for 5 time units
            $display("Sel=%0b en=%0b Y=%0b", Sel, en, Y);
        end

        // Test with enable low
        Sel = 3'b101; // Random selection
        en = 0;       // Disable the decoder
        #5;
        $display("Sel=%0b en=%0b Y=%0b", Sel, en, Y);

        $finish;
    end
endmodule