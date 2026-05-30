`include "defines.v"
/**
* 16-bit Logic Arithmetic Unit
*/
module alu (
  input [15:0] a, 
  input [15:0] b,
  output logic [15:0] out,
  output logic [3:0] flags // Z, C, V, N
  );

  logic z, c, v, n;
  assign flags = {z, c, v, n};

endmodule
