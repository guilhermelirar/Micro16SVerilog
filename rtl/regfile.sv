module reg_file(
  input write_en, rst_n, clk,
  input logic[3:0] r1_sel,
  input logic[3:0] r2_sel,
  input logic[15:0] data_in,

  output logic[15:0] data_out1,
  output logic[15:0] data_out2
);

  logic[15:0] regs[16];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      foreach(regs[i]) regs[i] <= '0;
    end
    else if (write_en) begin
      regs[r2_sel] <= data_in;
    end
  end

  // outside of clk, parallel
  always_comb begin
    // r0 always outputs 0
    data_out1 = (r1_sel == 4'h0) ? 16'h00 : regs[r1_sel];
    data_out2 = (r2_sel == 4'h0) ? 16'h00 : regs[r2_sel];
  end

endmodule: reg_file
