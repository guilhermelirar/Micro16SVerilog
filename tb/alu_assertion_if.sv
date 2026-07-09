`include "defines.v"

interface alu_assertions_if (
  input logic [15:0] a,
  input logic [15:0] b,
  input logic [15:0] alu_out,
  input logic [3:0] alu_ctrl,
  input logic z, c, v, n, clk
  );

  clocking cb @(posedge clk);
    default input #1step output #1;
    input z, c, v, n, alu_out, a, b, alu_ctrl;
  endclocking

  property p_zero_flag;
    (cb.alu_out == 16'h0000) <-> cb.z;
  endproperty

  property p_negative_flag;
    cb.alu_out[15] <-> cb.n;
  endproperty

  property p_overflow_add;
      (cb.alu_ctrl == `OP_ADD) |->
        ((!cb.a[15] && !cb.b[15] && cb.alu_out[15]) ||
         (cb.a[15] && cb.b[15] && !cb.alu_out[15]))
        <-> cb.v;
    endproperty

    property p_overflow_sub;
      (cb.alu_ctrl == `OP_SUB) |->
        ((!cb.a[15] && cb.b[15] && cb.alu_out[15]) ||
         (cb.a[15] && !cb.b[15] && !cb.alu_out[15]))
        <-> cb.v;
    endproperty

  property p_add_carry;
    (cb.alu_ctrl == `OP_ADD) |->
      {cb.c, cb.alu_out} == cb.a + cb.b;
  endproperty

  property p_sub;
    (cb.alu_ctrl == `OP_SUB) |->
      (cb.alu_out == cb.a - cb.b);
  endproperty


  assert_overflow_add:  assert property (@(cb) p_overflow_add);
  assert_overflow_sub:  assert property (@(cb) p_overflow_sub);
  assert_zero_flag:     assert property (@(cb) p_zero_flag);
  assert_negative_flag: assert property (@(cb) p_negative_flag);
  assert_add_c:         assert property (@(cb) p_add_carry);
  assert_sub:           assert property (@(cb) p_sub);

endinterface
