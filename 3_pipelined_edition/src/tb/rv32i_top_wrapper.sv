
module rv32i_top_wrapper (
    input clk,
    input rst_n
);

  parameter int K = 1024;
  parameter int M = K * K;
  parameter int G = M * K;

  parameter DATAMEM_FILE = "data_mem.mem";
  parameter DATAMEM_SIZE = 100 * K;
  parameter TEXTMEM_FILE = "text_mem.mem";
  parameter TEXTMEM_SIZE = 100 * K;

  initial begin
    if ($test$plusargs("vcd")) begin
      $dumpfile("dump.vcd");
      $dumpvars(0, DUT);
      $display("memory_size = %d",TEXTMEM_SIZE);
      $display("VCD tracing enabled");
    end
  end

  rv32i_top #(
      .DATAMEM_FILE(DATAMEM_FILE),
      .DATAMEM_SIZE(DATAMEM_SIZE),
      .TEXTMEM_FILE(TEXTMEM_FILE),
      .TEXTMEM_SIZE(TEXTMEM_SIZE)
  ) DUT (
      .clk  (clk),
      .rst_n(rst_n)
  );

endmodule
