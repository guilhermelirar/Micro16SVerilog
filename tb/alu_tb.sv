`include "defines.v"

module alu_tb;

  logic [3:0] operation;
  logic [15:0] a;
  logic [15:0] b;
  logic [15:0] out;
  logic [3:0] flags;

  logic z, c, v, n;
  assign {z, c, v, n} = flags;

  alu dut ( .operation(operation), .a(a), .b(b), .out(out), .flags(flags) );

  task check_result(
    input logic [15:0] a_in,
    input logic [15:0] b_in,
    input logic [3:0] op_in,
    input logic [15:0] expected
  );
  begin
    a  = a_in;
    b  = b_in;
    operation = op_in;

    #1;

    if (out !== expected)
      $error(
        "FAIL op=%0d a=%0d b=%0d expected=%0d got=%0d",
         op_in, a_in, b_in, expected, out
      );

    if (z != (out == 0))
      $error("FAIL flag Z");

    if (n != out[15])
      $error("FAIL flag N");

    if (op_in == `OP_ADD) begin
      if (v != ((~a[15] && ~b[15] && out[15]) 
        || (a[15] && b[15] && ~out[15])))
        $error("FAIL flag V");

      if (c != (({1'b0, a} + {1'b0, b}) >> 16))
        $error("FAIL incorrect carry flag");
    end 

  end
  endtask

  task test_random;
    logic [15:0] a_in;
    logic [15:0] b_in;

    for (int i = 0; i < 100; i++) begin
      a_in = $random;
      b_in = $random;
      check_result(a_in, b_in, `OP_ADD, a_in + b_in);     
    end 
  endtask

  initial begin 
    $display("--- Starting ALU simulation ---");
    $display("  A     B     Out    ZCVN ");
    $monitor(" %-5d  %-5d %-5d  %b ", a, b, out, flags);

    check_result(10, 20, `OP_ADD, 30);
    check_result(0, 0, `OP_ADD, 0);
    check_result(16'hffff, 1, `OP_ADD, 0);
    check_result(10, -20, `OP_ADD, -10);
    check_result(16'h7fff, 1, `OP_ADD, 16'h8000);
    test_random();

    $finish;
  end 

endmodule;
