// encapsulates PC behavior, stores PC
// increases +1 each clock, or set it to a value in case of jump
module program_counter(
  input logic clk, rst_n, jmp_n,
  input logic[15:0] jmp_addr,
  output logic[15:0] pc_out
);

logic[15:0] pc;

assign pc_out = pc;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) pc <= '0;
  else if (!jmp_n) pc <= jmp_addr;
  else pc++;
end

endmodule: program_counter
