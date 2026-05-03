class mem_scoreboard extends uvm_scoreboard;
  
  mem_seq_item pkt_qu[$];
  bit [7:0] sc_mem [4];
  uvm_analysis_imp#(mem_seq_item, mem_scoreboard) item_collected_export;
  `uvm_component_utils(mem_scoreboard)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
    foreach(sc_mem[i])
      sc_mem[i] = 8'hFF;
  endfunction
  
  virtual function void write(mem_seq_item pkt);
    pkt_qu.push_back(pkt);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    mem_seq_item mem_pkt;
    
    forever begin
      wait(pkt_qu.size() > 0);
      mem_pkt = pkt_qu.pop_front();
      
      if(mem_pkt.wr_en) begin
        sc_mem[mem_pkt.addr] = mem_pkt.wdata;
        `uvm_info(get_type_name(), $sformatf("------ :: WRITE DATA       :: ------"), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Addr: %0h", mem_pkt.addr), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Data: %0h", mem_pkt.wdata), UVM_LOW)
        `uvm_info(get_type_name(), "-------------------------------------", UVM_LOW)
      end
      else if(mem_pkt.rd_en) begin
        if(sc_mem[mem_pkt.addr] == mem_pkt.rdata) begin
          `uvm_info(get_type_name(), $sformatf("------ :: READ DATA PASS :: ------"), UVM_LOW)
        end
        else begin
          `uvm_info(get_type_name(), $sformatf("------ :: READ DATA FAIL :: ------"), UVM_LOW)
        end
        `uvm_info(get_type_name(), $sformatf("Addr: %0h", mem_pkt.addr), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Expected Data: %0h Actual Data: %0h", sc_mem[mem_pkt.addr], mem_pkt.rdata), UVM_LOW)
        `uvm_info(get_type_name(), "-------------------------------------", UVM_LOW)
      end
    end
  endtask
endclass
