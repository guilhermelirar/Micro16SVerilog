interface regfile_io(input bit clk);
  logic        write_en;
  logic        rst_n;
  logic [3:0]  r1_sel;
  logic [3:0]  r2_sel;
  logic [15:0] data_in;
  logic [15:0] data_out1;
  logic [15:0] data_out2;

  clocking cb @(posedge clk);
    input data_out1, data_out2;
    output r1_sel, r2_sel, data_in, write_en;
  endclocking

  modport TB(clocking cb, output rst_n);
endinterface: regfile_io
