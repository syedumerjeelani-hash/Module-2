
module leading_zero_tree (
    input  logic [31:0] data_in,
    output logic [5:0]  count
);

    logic [1:0] c2  [0:15];
    logic [2:0] c4  [0:7];
    logic [3:0] c8  [0:3];
    logic [4:0] c16 [0:1];

    logic [15:0] v2;
    logic [7:0]  v4;
    logic [3:0]  v8;
    logic [1:0]  v16;

    logic [5:0] c32;
    logic v32;

    integer i;

    always_comb begin

        // Stage 1: 2-bit groups
        for (i = 0; i < 16; i = i + 1) begin
            v2[i] = |data_in[31-2*i -: 2];

            if (data_in[31-2*i])
                c2[i] = 0;
            else if (data_in[30-2*i])
                c2[i] = 1;
            else
                c2[i] = 2;
        end

        // Stage 2: 4-bit groups
        for (i = 0; i < 8; i = i + 1) begin
            v4[i] = v2[2*i] | v2[2*i+1];

            if (v2[2*i])
                c4[i] = c2[2*i];
            else
                c4[i] = 2 + c2[2*i+1];
        end

        // Stage 3: 8-bit groups
        for (i = 0; i < 4; i = i + 1) begin
            v8[i] = v4[2*i] | v4[2*i+1];

            if (v4[2*i])
                c8[i] = c4[2*i];
            else
                c8[i] = 4 + c4[2*i+1];
        end

        // Stage 4: 16-bit groups
        for (i = 0; i < 2; i = i + 1) begin
            v16[i] = v8[2*i] | v8[2*i+1];

            if (v8[2*i])
                c16[i] = c8[2*i];
            else
                c16[i] = 8 + c8[2*i+1];
        end

        // Stage 5: 32-bit result
        v32 = v16[0] | v16[1];

        if (v16[0])
            c32 = c16[0];
        else
            c32 = 16 + c16[1];

        if (v32)
            count = c32;
        else
            count = 32;

    end

endmodule
