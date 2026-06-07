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

  assert property (@(out) (out == 16'h0000) -> z);
  assert property (@(out) (operation == `OP_ADD) -> {c, out} == a + b);
  assert property (@(out) out[15] -> n);

  task test_random;
    for (int i = 0; i < 100; i++) begin
      a = $random;
      b = $random;
      operation <= `OP_ADD;
    end 
  endtask

  initial begin
    $assertoff(0, alu_tb);
    operation = 3'b0;
    a = 16'h0000;
    b = 16'h0000;

    #1;
    $asserton(0, alu_tb);

    forever begin
        test_random();
        #1; 
    end
  end

  initial begin 
    $display("--- Starting ALU simulation ---");
    // $monitor(" %-5d  %-5d %-5d  %b ", a, b, out, flags);
    $finish;
  end 

endmodule;
