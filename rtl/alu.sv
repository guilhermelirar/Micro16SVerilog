`include "defines.v"
/**
* 16-bit Logic Arithmetic Unit
*/
module alu (
  input [3:0] operation,
  input [15:0] a, 
  input [15:0] b,
  output logic [15:0] out,
  output logic [3:0] flags // Z, C, V, N
  );

  logic z, c, v, n;
  assign flags = {z, c, v, n};
  assign z = (out == 0);
  assign n = (out[15]);

  always_comb begin
    case (operation)
      `OP_ADD: begin
        {c, out} = a + b;
        v = (~a[15] & ~b[15] & n) |  // a, b > 0 out < 0
            (a[15] & b[15] & ~n);     // a, b < 0 out > 0
      end

      `OP_SUB: begin
        out = a - b;
        v = (~a[15] & b[15] & n) | 
          (a[15] & ~b[15] & ~n); 
      end 

      `OP_SHR: begin 
        out = a >> b & 4'hF;
        v = 0; c = 0; // TODO
      end 

      `OP_SHL: begin 
        out = a << b & 4'hF;
        v = 0; c = 0; // TODO
      end 

      `OP_OR: begin 
        out = a | b;
        v = 0; c = 0;
      end

      `OP_AND: begin 
        out = a & b;
        v = 0; c = 0;
      end

      `OP_XOR: begin 
        out = a ^ b;
        v = 0; c = 0;
      end

      `OP_PASS: begin 
        out = b;
        v = 0; c = 0;
      end 
    endcase 
  end 

endmodule
