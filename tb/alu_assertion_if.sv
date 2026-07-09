`include "defines.v"

interface alu_assertions_if (
  input logic [15:0] a,
  input logic [15:0] b,
  input logic [15:0] alu_out,
  input logic [3:0] alu_ctrl,
  input logic z, c, v, n, clk
  );

  logic a_neg, b_neg, out_neg;
  assign {a_neg, b_neg, out_neg} = {a[15], b[15], alu_out[15]};

  property p_zero_flag;
    @(posedge clk) (alu_out == 16'h0000) <-> z;
  endproperty

  property p_negative_flag;
    @(posedge clk) out_neg <-> n;
  endproperty

  property p_overflow_add;
    @(posedge clk) (alu_ctrl == `OP_ADD) |->
      // pos + pos = neg (overflow)
      ((!a_neg && !b_neg && out_neg) ||
      // neg + neg = pos (overflow)
       (a_neg && b_neg && !out_neg))
      <-> v;
  endproperty

  property p_overflow_sub;
    @(posedge clk) (alu_ctrl == `OP_SUB) |->
      // pos - neg = neg (overflow)
      ((!a_neg && b_neg && out_neg) ||
      // neg - pos = pos (overflow)
       (a_neg && !b_neg && !out_neg))
      <-> v;
  endproperty

  property p_add_carry;
    @(posedge clk) (alu_ctrl == `OP_ADD) |->
      {c, alu_out} == a + b;
  endproperty

  property p_sub;
    @(posedge clk) (alu_ctrl == `OP_SUB) |->
      (alu_out == a - b);
  endproperty

  assert_overflow_add: assert property (p_overflow_add);
  assert_overflow_sub: assert property (p_overflow_sub);
  assert_zero_flag:    assert property (p_zero_flag);
  assert_negative_flag: assert property (p_negative_flag);
  assert_add_c: assert property (p_add_carry);
  assert_sub: assert property (p_sub);

endinterface
