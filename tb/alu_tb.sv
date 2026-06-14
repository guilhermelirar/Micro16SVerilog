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
  
  alu_assertions_if fiscal_inst (
    .operand_a(a), .operand_b(b),
    .alu_out(out), .alu_ctrl(operation),
    .z(z), .c(c), .v(v), .n(n)
    );

  task test_random;
    for (int i = 0; i < 100; i++) begin
      a = $random;
      b = $random;
      operation = `OP_ADD;
    end 
  endtask

  initial begin
    $assertoff(0, alu_tb);
    operation = 3'b0;
    a = 16'h0000;
    b = 16'h0000;
    #10;
    $asserton(0, alu_tb);

    forever begin
        test_random();
        #1; 
    end
  end

  initial begin 
    #100 $finish;
  end 

endmodule;
