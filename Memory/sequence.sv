class mem_sequence extends uvm_sequence#(mem_seq_item);
  
  `uvm_sequence_utils(mem_sequence, mem_sequencer)
  
  function new(string name = "mem_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    req = mem_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
  
endclass
