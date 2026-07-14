module regfile_tb;
  int SIMULATION_CYCLE = 100;
  bit SystemClock = 0;

  regfile_io top_io(SystemClock);

  logic [15:0] golden_regfile[16];

  reg_file u_dut (
    .clk      (top_io.clk),
    .rst_n    (top_io.rst_n),
    .write_en (top_io.write_en),
    .r1_sel   (top_io.r1_sel),
    .r2_sel   (top_io.r2_sel),
    .data_in  (top_io.data_in),
    .data_out1(top_io.data_out1),
    .data_out2(top_io.data_out2)
  );

  always begin
    #(SIMULATION_CYCLE/2) SystemClock = ~SystemClock;
  end

  task reset();
    foreach(golden_regfile[i]) golden_regfile[i] = '0;
    top_io.rst_n = 0;
    #20;
    top_io.rst_n = 1;
    @(top_io.cb);
  endtask

  task automatic write_read();
    logic[3:0] r1 = $urandom;
    logic[3:0] r2 = $urandom;
    logic[15:0] data = $urandom;

    if (r2 != '0) golden_regfile[r2] = data;
    @top_io.cb;
    top_io.cb.write_en <= 1;
    top_io.cb.r1_sel <= r1;
    top_io.cb.r2_sel <= r2;
    top_io.cb.data_in <= data;

    @top_io.cb;
    top_io.cb.write_en <= 0;

    @top_io.cb;
    if (top_io.cb.data_out1 != golden_regfile[r1] ||
      top_io.cb.data_out2 != golden_regfile[r2]) begin
        $display("[ERROR] (write 0x%h)", data);
        $display("\tgot: r%0d:0x%h r%0d:0x%h instead of r%0d:0x%h r%0d:0x%h",
          r1, top_io.cb.data_out1, r2, top_io.cb.data_out2,
          r1, golden_regfile[r1], r2, golden_regfile[r2]);
        $finish;
    end

    $display("[NOTE] W 0x%h; read r%0d:0x%h, r%0d:0x%h",
      data, r2, r1, top_io.cb.data_out1, r2, top_io.cb.data_out2);

  endtask

  initial begin
    reset();
    repeat (100) write_read();
    $finish;
  end
endmodule: regfile_tb
