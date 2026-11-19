module tb_HA;

    logic A, B, Cin;
    
    logic Sum1, Cout1;
    logic Sum2, Cout2;

    HA ha_top(
        .A(A),
        .B(B),
        .C(A),       // Connect TB 'A' to module 'C'
        .D(B),       // Connect TB 'B' to module 'D'
        .Cin(Cin),
        .Sum1(Sum1), 
        .Cout1(Cout1),
        .Sum2(Sum2), 
        .Cout2(Cout2)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Test case 1: A=0, B=0
        A = 0; B = 0; Cin = 0;
        #10;
        $display("Time=%0t | Inputs: A=%b, B=%b | Assign HA: Sum=%b, Cout=%b | If-Else HA: Sum=%b, Cout=%b", 
                 $time, A, B, Sum1, Cout1, Sum2, Cout2);

        // Test case 2: A=0, B=1
        A = 0; B = 1; Cin = 0;
        #10;
        $display("Time=%0t | Inputs: A=%b, B=%b | Assign HA: Sum=%b, Cout=%b | If-Else HA: Sum=%b, Cout=%b", 
                 $time, A, B, Sum1, Cout1, Sum2, Cout2);

        // Test case 3: A=1, B=0
        A = 1; B = 0; Cin = 0;
        #10;
        $display("Time=%0t | Inputs: A=%b, B=%b | Assign HA: Sum=%b, Cout=%b | If-Else HA: Sum=%b, Cout=%b", 
                 $time, A, B, Sum1, Cout1, Sum2, Cout2);

        // Test case 4: A=1, B=1
        A = 1; B = 1; Cin = 0;
        #10;
        $display("Time=%0t | Inputs: A=%b, B=%b | Assign HA: Sum=%b, Cout=%b | If-Else HA: Sum=%b, Cout=%b", 
                 $time, A, B, Sum1, Cout1, Sum2, Cout2);

        $finish;
    end
endmodule