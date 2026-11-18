module dec(
    input logic [1:0] Sel, 
    input logic en,
    output logic [3:0] Y
);

    always_comb begin
      if(en) begin
        case (Sel[1:0]) // Use only the two least significant bits for selection
            2'b00: Y = 4'b0001;
            2'b01: Y = 4'b0010;
            2'b10: Y = 4'b0100;
            2'b11: Y = 4'b1000;
            default: Y = 4'b0000; // Default case to handle unexpected inputs
        endcase
    end
    else begin
        Y = 3'b0000; // Default case to handle unexpected inputs
    end
    end
endmodule