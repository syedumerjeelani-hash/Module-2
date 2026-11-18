// Code your testbench here
module tb; 
    logic a, b, y, x, z;
  
  logic_gate dut (.a(a), .b(b), .y(y), .x(x), .z(z));
  initial begin 
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb); 
  
        a = 0; b = 0; #5; 
   		$display("a=%0b b=%0b y=%0b x=%0b z=%0b", a, b, y, x, z);
        a = 0; b = 1; #5; 
        $display("a=%0b b=%0b y=%0b x=%0b z=%0b", a, b, y, x, z);
        a = 1; b = 0; #5; 
        $display("a=%0b b=%0b y=%0b x=%0b z=%0b", a, b, y, x, z); 
        a = 1; b = 1; #5; 
        $display("a=%0b b=%0b y=%0b x=%0b z=%0b", a, b, y, x, z); 
  		#5
        $finish; 
    end 
endmodule