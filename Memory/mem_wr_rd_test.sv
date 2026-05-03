class mem_wr_rd_test extends mem_model_base_test;
  `uvm_component_utils(mem_wr_rd_test)
  
  wr_rd_sequence seq;
  
  function new(string name = "mem_wr_rd_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = wr_rd_sequence::type_id::create("seq");
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      seq.start(env.mem_agt.sequencer);
    phase.drop_objection(this);
    
    phase.phase_done.set_drain_time(this, 50);
  endtask
endclass
