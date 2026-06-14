`include "defines.v"

interface alu_assertions_if (
  input logic [15:0] operand_a,
  input logic [15:0] operand_b,
  input logic [15:0] alu_out,
  input logic [3:0] alu_ctrl,
  input logic z, c, v, n
  );

  assert property (@(alu_out) (alu_out == 16'h0000) <-> z);
  assert property (@(alu_out) (alu_ctrl == `OP_ADD) -> 
    {c, alu_out} == operand_a + operand_b);
  assert property (@(alu_out) alu_out[15] -> n);
endinterface

