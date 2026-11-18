// Code your testbench here
module tb; 
    logic a, b, y, x, z;
  
    // Instantiate your design (assuming y=AND, x=OR, z=XOR based on your comment)
    logic_gate dut (.a(a), .b(b), .y(y), .x(x), .z(z));
  
    initial begin 
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb); 
  
        // Test case 1: 0, 0
        a = 0; b = 0; #5; 
        $display("Time=%0t: a=%0b b=%0b | y(AND)=%0b x(OR)=%0b z(XOR)=%0b", $time, a, b, y, x, z);
        check(y, 1'b0, "AND Gate");
        check(x, 1'b0, "OR Gate");
        check(z, 1'b0, "XOR Gate");

        // Test case 2: 0, 1
        a = 0; b = 1; #5; 
        $display("Time=%0t: a=%0b b=%0b | y(AND)=%0b x(OR)=%0b z(XOR)=%0b", $time, a, b, y, x, z);
        check(y, 1'b0, "AND Gate");
        check(x, 1'b1, "OR Gate");
        check(z, 1'b1, "XOR Gate");

        // Test case 3: 1, 0
        a = 1; b = 0; #5; 
        $display("Time=%0t: a=%0b b=%0b | y(AND)=%0b x(OR)=%0b z(XOR)=%0b", $time, a, b, y, x, z);
        check(y, 1'b0, "AND Gate");
        check(x, 1'b1, "OR Gate");
        check(z, 1'b1, "XOR Gate"); 

        // Test case 4: 1, 1
        a = 1; b = 1; #5; 
        $display("Time=%0t: a=%0b b=%0b | y(AND)=%0b x(OR)=%0b z(XOR)=%0b", $time, a, b, y, x, z);
        check(y, 1'b1, "AND Gate");
        check(x, 1'b1, "OR Gate");
        check(z, 1'b0, "XOR Gate"); 

        #5; // Fixed missing semicolon here
        $finish; 
    end

    // Your check task 
    task automatic check(input logic actual, expected, string name); 
        if (actual !== expected) 
            $display("[FAIL] %s: expected=%0b actual=%0b at time=%0t", name, expected, actual, $time);
        else 
            $display("[PASS] %s: value=%0b at time=%0t", name, actual, $time); 
    endtask 
endmodule