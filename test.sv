class test extends uvm_test;
  
  `uvm_component_utils(test)
  
  vend_env env;
  vend_sequence seq;
  reset_seq seq1;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env   = vend_env::type_id::create("env",this);
      seq   = vend_sequence::type_id::create("seq");
      seq1  = reset_seq::type_id::create("seq1");
      if(!uvm_config_db#(virtual vend_if)::get(this, "", "vif", seq1.vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  task run_phase(uvm_phase phase);
      $display("inside run_phase");
      phase.raise_objection(this);
      seq1.start(env.vend_agnt.sequencer);
      seq.start(env.vend_agnt.sequencer);
      phase.drop_objection(this);
  endtask
endclass
