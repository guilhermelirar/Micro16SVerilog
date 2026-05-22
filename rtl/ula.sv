/**
* 16-bit Logic Arithmetic Unit
*/
parameter
  // Arith
  OP_ADD = 4'h0,
  OP_SUB = 4'h1,
  
  // Logic
  OP_SHR = 4'h2,
  OP_SHL = 4'h3,
  OP_OR  = 4'h4,
  OP_AND = 4'h5
  OP_XOR = 4'h6,

  // OUT = B
  OP_PASS = 4'hf;

module ALU_16 (
  input [15:0] a, b;
  output logic [15:0] out;
  output logic [3:0] flags; // Z, C, V, N
  );

  logic z, c, v, n;
  assign flags = {z, c, v, n};

endmodule;
