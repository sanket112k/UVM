`include "mem_interface.sv"
`include "mem_base_test.sv"
`include "mem_wr_rd_test.sv"

module tbench_top;
  //import uvm_pkg::*;
  //import test_pkg::*;
  
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5 reset = 0;
  end
  
  mem_if intf(clk, reset);
  
  memory DUT(
    .clk(intf.clk),
    .reset(intf.reset),
    .addr(intf.addr),
    .wr_en(intf.wr_en),
    .rd_en(intf.rd_en),
    .wdata(intf.wdata),
    .rdata(intf.rdata)
  );
  
  initial begin
    uvm_config_db#(virtual mem_if)::set(uvm_root::get(), "*", "vif", intf);
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    run_test("mem_wr_rd_test");
  end
endmodule
