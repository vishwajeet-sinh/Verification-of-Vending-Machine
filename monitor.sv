class vend_monitor_op extends uvm_monitor;
  
  // Virtual Interface
  virtual vend_if vif;
  
  uvm_analysis_port #(vend_seq_item) item_collected_port;
  
  // Placeholder to capture transaction information.
  vend_seq_item trans_collected_1,trans_collected_2;
  `uvm_component_utils(vend_monitor_op)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected_1 = new();
    trans_collected_2= new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual vend_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  // run phase
  virtual task run_phase(uvm_phase phase);
      fork :p1
          //for detecting nededge of detect signal
            forever begin
                @(negedge vif.MONITOR.detect_5);
                trans_collected_1.oper = vend_seq_item :: send_5;
                trans_collected_1.amount = 5;
                item_collected_port.write(trans_collected_1);
            end
            forever begin
                @(negedge vif.MONITOR.detect_10);
                trans_collected_1.oper = vend_seq_item :: send_10;
                trans_collected_1.amount = 10;
                item_collected_port.write(trans_collected_1);
            end
            forever begin
                @(negedge vif.MONITOR.detect_25);
                trans_collected_1.oper = vend_seq_item :: send_25;
                trans_collected_1.amount = 25;
                item_collected_port.write(trans_collected_1);
            end
          //for detecting buy signal
           forever begin
               @(posedge vif.MONITOR.buy);
               trans_collected_1.oper = vend_seq_item :: buy;
               trans_collected_1.amount = vif.MONITOR.amount;
               item_collected_port.write(trans_collected_1);
           end
           //for detecting empty signal
           forever begin
                @(negedge vif.MONITOR.empty_5);
                trans_collected_2.oper = vend_seq_item :: return_coin;
                trans_collected_2.emp_type = vend_seq_item::empty_5; 
                item_collected_port.write(trans_collected_2);
           end
           forever begin
                @(negedge vif.MONITOR.empty_10);
                trans_collected_2.oper = vend_seq_item :: return_coin;
                trans_collected_2.emp_type = vend_seq_item::empty_10; 
                item_collected_port.write(trans_collected_2);

           end
           forever begin
                @(negedge vif.MONITOR.empty_25);
                trans_collected_2.oper = vend_seq_item :: return_coin;
                trans_collected_2.emp_type = vend_seq_item::empty_25; 
                item_collected_port.write(trans_collected_2);
           end
      join
  endtask : run_phase
endclass : vend_monitor_op
