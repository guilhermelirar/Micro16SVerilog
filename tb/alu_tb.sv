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

  always @* begin
    #1;
    if (operation == `OP_ADD) begin
      asm_sum: assert ({c, out} == a + b);
    end

    if (out == 0)
      asm_zero_1: assert (z == 1'b1);
    else
      asm_zero_0: assert (z == 1'b0);
  
  end

  task test_random;
    for (int i = 0; i < 100; i++) begin
      a = $random;
      b = $random;
      operation <= `OP_ADD;
    end 
  endtask

  initial begin 
    $display("--- Starting ALU simulation ---");
    $display("  A     B     Out    ZCVN ");
    $monitor(" %-5d  %-5d %-5d  %b ", a, b, out, flags);

    forever #1 test_random();
  end

  initial begin 
    $display("--- Starting ALU simulation ---");
    $display("  A     B     Out    ZCVN ");
    $monitor(" %-5d  %-5d %-5d  %b ", a, b, out, flags);


    #200 $finish;
  end 

endmodule;
