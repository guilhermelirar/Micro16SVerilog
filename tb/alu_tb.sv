`include "defines.v"

module alu_tb;

  logic [3:0] operation;
  logic [15:0] a;
  logic [15:0] b;
  logic [15:0] out;
  logic [3:0] flags;

  logic z, c, v, n;
  assign {z, c, v, n} = flags;
  logic clk;

  alu dut (
      .operation(operation),
      .a(a),
      .b(b),
      .out(out),
      .flags(flags)
    );

  bind alu alu_assertions_if fiscal_inst (
    .a(a),
    .b(b),
    .alu_out(out),
    .alu_ctrl(operation),
    .z(flags[3]), .c(flags[2]), .v(flags[1]), .n(flags[0]),
    .clk(alu_tb.clk)
  );

  task apply_stimulus(int quantity);
    for (int i = 0; i < quantity; i++) begin
     @(negedge clk);
     operation = $urandom_range(0, 15);
     a         = $urandom_range(0, 16'hFFFF);
     b         = $urandom_range(0, 16'hFFFF);
    end
  endtask

  initial begin
    fork
      begin
        clk = 0;
        $assertoff(0, alu_tb);
        operation = 4'b0;
        a = 16'h0000;
        b = 16'h0000;
        #15;
        $asserton(0, alu_tb);
        apply_stimulus(1000);       end

      forever #10 clk = ~clk;
    join_any

    $display("--- Sucesso: Todos os 1000 testes foram aplicados! ---");
    $finish;
  end

endmodule;
