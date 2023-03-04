class vend_env extends uvm_env;
  
  vend_agent      vend_agnt;
  vend_scoreboard vend_scb;
   
  `uvm_component_utils(vend_env)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    vend_agnt = vend_agent::type_id::create("vend_agnt", this);
    vend_scb  = vend_scoreboard::type_id::create("vend_scb", this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    vend_agnt.monitor.item_collected_port.connect(vend_scb.op_analysis_imp);
    vend_agnt.monitor_dut.dut_item_collected_port.connect(vend_scb.dut_analysis_imp);
  endfunction : connect_phase
endclass : vend_env
