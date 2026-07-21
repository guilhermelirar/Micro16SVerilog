module control_unit(
  input clk,
  input logic [15:0] instruction,
  output logic [3:0] alu_op,
  output reg_write_en,
  output logic [3:0] r1_sel,
  output logic [3:0] r2_sel,
  output jmp_n
);

  logic [3:0] r1, r2;
  logic [3:0] opc;
  assign opc = instruction[15:12];
  assign r1 = instruction[11:8];
  assign r2 = instruction[7:4];
  assign funct3 = instruction[3:0];

// starting with basic
// R-TYPE
always_comb begin
  case (opc)
    '0: begin
      r2_sel = r2;
      r1_sel = r1;
      jmp_n = 1;
      reg_write_en = 1'b0;
      jmp_n = 1'b1;
    end

    default: ;

  endcase
end

endmodule: control_unit
