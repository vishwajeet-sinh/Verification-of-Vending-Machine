class vend_driver extends uvm_driver #(vend_seq_item);
  
  `uvm_component_utils(vend_driver)
  
  // Virtual Interface
  virtual vend_if vif;
  
  // Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual vend_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  // run phase
  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(req);
    fork
    drive();
    begin
        @(posedge vif.TB.rst) begin
        vif.TB.detect_5 <= 0;
        vif.TB.detect_10 <= 0;
        vif.TB.detect_25 <= 0;
        vif.TB.buy<= 0;
        vif.TB.return_coins<= 0;
        vif.TB.empty_5 <= 1 ;
        vif.TB.empty_10 <= 1;
        vif.TB.empty_25 <= 1;
        vif.TB.amount<= 0;
        end
      `uvm_info("DRV","reseted posedge ofrst ",UVM_LOW)
    end
    join_any
    seq_item_port.item_done();
    end
  endtask : run_phase
 
  // drive
  virtual task drive();
  if(vif.TB.rst ==0 ) begin
      @(negedge vif.TB.clk);
      vif.TB.detect_5 <= 0;
      vif.TB.detect_10 <= 0;
      vif.TB.detect_25 <= 0;
      vif.TB.buy<= 0;
      vif.TB.return_coins<= 0;
      vif.TB.empty_5 <= 1;
      vif.TB.empty_10 <= 1;
      vif.TB.empty_25 <= 1;
      case(req.oper)
          vend_seq_item::send_5: vif.TB.detect_5<=1;
          vend_seq_item::send_10: vif.TB.detect_10<=1;
          vend_seq_item::send_25: vif.TB.detect_25<=1;
          vend_seq_item::return_coin: vif.TB.return_coins<=1;
          vend_seq_item::buy: vif.TB.buy<=1;
      endcase
      vif.TB.amount<= req.amount;
      case(req.emp_type)
          vend_seq_item::empty_5: vif.TB.empty_5<=0;
          vend_seq_item::empty_10: vif.TB.empty_10<=0;
          vend_seq_item::empty_25: vif.TB.empty_25<=0;
          vend_seq_item::no_empty : begin
                                        vif.TB.empty_5 <= 1;
                                        vif.TB.empty_10 <= 1;
                                        vif.TB.empty_25 <= 1;

                                    end
      endcase
      @(negedge vif.TB.clk);
      repeat(req.del) @(posedge vif.TB.clk);
  end
  else begin
    vif.TB.detect_5 <= 0;
    vif.TB.detect_10 <= 0;
    vif.TB.detect_25 <= 0;
    vif.TB.buy<= 0;
    vif.TB.return_coins<= 0;
    vif.TB.empty_5 <= 1;
    vif.TB.empty_10 <= 1;
    vif.TB.empty_25 <= 1;
    vif.TB.amount<= 0;
    `uvm_info("DRV","reseted ofrst ",UVM_LOW)

  end
  endtask : drive
 
endclass : vend_driver
