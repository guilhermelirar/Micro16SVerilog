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
      $error("FAIL flag Z not set when output 0");

    if (n != (out < 0))
      $error("FAIL flag N not set when out < 0");

    if (op_in == `OP_ADD) begin
      if (v != ((a < 0 && b < 0 && out > 0) 
        || (a > 0 && b > 0 && out < 0)))
        $error("FAIL flag V not set when overflow");

      if (c != (a + b > 255))
        $error("FAIL incorrect carry flag");
    end 

  end
  endtask


  initial begin 
    $display("--- Starting ALU simulation ---");
    $display("  A    B    Out   ZCVN ");
    $monitor(" %3d %3d %4d %b ", a, b, out, flags);

    check_result(10, 20, `OP_ADD, 30);
    check_result(0, 0, `OP_ADD, 0);

    $finish;
  end 

endmodule;
