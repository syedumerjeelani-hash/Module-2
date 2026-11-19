module Decoder(
    input  logic [2:0] Sel,
    input  logic       en,
    output logic [7:0] Y
);

    dec dec_lower (
        .Sel(Sel[1:0]),
        .en(en & ~Sel[2]),  // Enabled ONLY when MSB is 0 and overall 'en' is high
        .Y(Y[3:0])          // Driving lower 4 bits of the output
    );

    dec dec_upper (
        .Sel(Sel[1:0]),
        .en(en & Sel[2]),   // Enabled ONLY when MSB is 1 and overall 'en' is high
        .Y(Y[7:4])          // Driving upper 4 bits of the output
    );

endmodule