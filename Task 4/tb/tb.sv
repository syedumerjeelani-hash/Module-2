module tb;

    logic A, B, C, D;
    logic y, f;

    NOR_Gate NOR_inst(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .y(y),
        .f(f)
    );

    initial begin
        // Testing all combinations of inputs A, B, C, D
        $display("A B C D | y f");
        for (int i = 0; i < 16; i++) begin
            {A, B, C, D} = i;
            #5;
            $display("%b %b %b %b | %b %b", A, B, C, D, y, f);
        end
        $finish;
    end
endmodule