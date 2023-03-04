class vend_sequencer extends uvm_sequencer#(vend_seq_item);
  
  `uvm_component_utils(vend_sequencer)
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

class vend_agent extends uvm_agent;
  
  //declaring vend_agent components
  vend_driver    driver;
  vend_sequencer sequencer;
  vend_monitor_op   monitor; 
  vend_monitor_dut  monitor_dut;

  // UVM automation macros for general components
  `uvm_component_utils(vend_agent)
  
  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      driver = vend_driver::type_id::create("driver", this);
      sequencer = vend_sequencer::type_id::create("sequencer", this);
      monitor = vend_monitor_op::type_id::create("monitor", this);
      monitor_dut = vend_monitor_dut::type_id::create("monitor_dut", this);
  endfunction : build_phase
  
  // connect_phase
  function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase
endclass : vend_agent
