`include "defines.v"

interface alu_assertions_if (
  input logic [15:0] operand_a,
  input logic [15:0] operand_b,
  input logic [15:0] alu_out,
  input logic [3:0] alu_ctrl,
  input logic z, c, v, n
  );

  logic a_neg, b_neg, out_neg;
  assign {a_neg, b_neg, out_neg} = {operand_a[15], operand_b[15], alu_out[15]};

  property p_zero_flag;
    @(alu_out) (alu_out == 16'h0000) <-> z;
  endproperty

  property p_negative_flag;
    @(alu_out) out_neg <-> n;
  endproperty

  property p_overflow_add;
    @(alu_out) (alu_ctrl == `OP_ADD) |->
      // pos + pos = neg (overflow)
      ((!a_neg && !b_neg && out_neg) || 
      // neg + neg = pos (overflow)
       (a_neg && b_neg && !out_neg)) 
      <-> v; 
  endproperty

  property p_overflow_sub;
    @(alu_out) (alu_ctrl == `OP_SUB) |->
      // pos - neg = neg (overflow)
      ((!a_neg && !b_neg && out_neg) || 
      // neg - pos = pos (overflow)
       (a_neg && b_neg && !out_neg)) 
      <-> v; 
  endproperty

  property p_add_carry;
    @(alu_out) (alu_ctrl == `OP_ADD) |->
      {c, alu_out} == operand_a + operand_b;
  endproperty;

  assert_overflow_add: assert property (p_overflow_add);
  assert_overflow_sub: assert property (p_overflow_sub);
  assert_zero_flag:    assert property (p_zero_flag);
  assert_negative_flag: assert property (p_negative_flag);
  assert_add_c: assert property (p_add_carry);

endinterface

