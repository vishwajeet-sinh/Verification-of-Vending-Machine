class vend_monitor_dut extends uvm_monitor;
  
  // Virtual Interface
  virtual vend_if vif;
  
  uvm_analysis_port #(vend_seq_item) dut_item_collected_port;
  
  // Placeholder to capture transaction information.
  vend_seq_item trans_collected_1,trans_collected_2;
  `uvm_component_utils(vend_monitor_dut)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected_1 = new();
    trans_collected_2= new();
    dut_item_collected_port = new("dut_item_collected_port", this);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual vend_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  // run phase
  virtual task run_phase(uvm_phase phase);
    //for detecting return signal
    fork
        forever begin
            @(posedge vif.DUT_MON.ok);
            trans_collected_1.oper = vend_seq_item::buy;
            trans_collected_1.amount = vif.DUT_MON.amount;
            dut_item_collected_port.write(trans_collected_1);
        end
        forever begin
            wait(vif.DUT_MON.return_coins==1'b1);
            fork:p1
              begin
                @(posedge vif.DUT_MON.return_5);
                trans_collected_2.oper = vend_seq_item:: return_coin;
                trans_collected_2.ret_type = vend_seq_item::return_5; 
                trans_collected_2.amount = 5;
                dut_item_collected_port.write(trans_collected_2);
              end
              begin
                @(posedge vif.DUT_MON.return_10);
                trans_collected_2.oper = vend_seq_item:: return_coin;
                trans_collected_2.ret_type = vend_seq_item::return_10; 
                trans_collected_2.amount = 10;
                dut_item_collected_port.write(trans_collected_2);
              end
              begin
                @(posedge vif.DUT_MON.return_25);
                trans_collected_2.oper = vend_seq_item:: return_coin;
                trans_collected_2.ret_type = vend_seq_item::return_25; 
                trans_collected_2.amount = 25;
                dut_item_collected_port.write(trans_collected_2);
              end
            join_any
            disable p1;
        end
    join
  endtask : run_phase
endclass : vend_monitor_dut

