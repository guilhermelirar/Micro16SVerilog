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

  task test();
    bit [15:0] operand_a;
    bit [15:0] operand_b;
    bit [3:0]  alu_ctrl;

    operand_a = $urandom(); 
    operand_b = $urandom();
    
    alu_ctrl  = $urandom_range(0, 15); 

    operation = alu_ctrl;
    a         = operand_a; 
    b         = operand_b;
    
    #5; 
  endtask

  initial begin
    $assertoff(0, alu_tb);
    operation = 3'b0;
    a = 16'h0000;
    b = 16'h0000;
    #10;
    $asserton(0, alu_tb);

    forever begin
        test();
    end
  end

  initial begin 
    #500 $finish;
  end 

endmodule;
