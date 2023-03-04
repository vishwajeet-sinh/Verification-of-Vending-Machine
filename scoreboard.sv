`uvm_analysis_imp_decl(_oper_monitor)
`uvm_analysis_imp_decl(_dut_monitor)

class vend_scoreboard extends uvm_scoreboard;

  // Virtual Interface
  virtual vend_if vif;
  
  bit signed [8:0] ref_total;
  bit signed [9:0] actual_total;
  bit signed [8:0] amo;
  bit disable_check;
  bit flag_empty_5,flag_empty_10,flag_empty_25;
  bit flag_return_5,flag_return_10,flag_return_25;

  uvm_analysis_imp_oper_monitor #(vend_seq_item,vend_scoreboard) op_analysis_imp; 
  uvm_analysis_imp_dut_monitor #(vend_seq_item,vend_scoreboard) dut_analysis_imp; 
  
  `uvm_component_utils(vend_scoreboard)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    op_analysis_imp = new("op_analysis_imp", this);
    dut_analysis_imp = new("dut_analysis_imp", this);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual vend_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  virtual function void write_oper_monitor(vend_seq_item trans);
    `uvm_info(get_type_name(),$sformatf(" Printing trans received from oper_MON, \n %s",
                                          trans.sprint()),UVM_LOW)
   case(trans.oper)
       vend_seq_item::send_5: begin ref_total+= trans.amount; actual_total+=trans.amount; end
       vend_seq_item::send_10: begin ref_total+= trans.amount;actual_total+=trans.amount; end
       vend_seq_item::send_25: begin ref_total+= trans.amount;actual_total+=trans.amount; end
       vend_seq_item::return_coin: begin
         case(trans.emp_type)
             vend_seq_item::empty_5 : begin flag_empty_5=1; ref_total-=5; end
             vend_seq_item::empty_10 : begin flag_empty_10=1; ref_total-=10; end
             vend_seq_item::empty_25 : begin flag_empty_25=1; ref_total-=25; end
         endcase
       end
       vend_seq_item::buy: begin ref_total-=trans.amount; amo= trans.amount; if (ref_total==0)disable_check=1; end
   endcase
   
   if(ref_total<0 && disable_check==0) 
     `uvm_error("SCB",$sformatf("ref_total=%0d which is negative so design is not working correctly ",ref_total))
   else if (ref_total<5) begin 
       ref_total=0;
   end

  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    fork :r1
        forever begin
            @(posedge flag_empty_5);
            fork :r2
                @(posedge flag_return_5);
                begin
                    repeat(200) @(posedge vif.clk);
                    `uvm_error("SCB", $sformatf("return_5 is not asserted in responds to empty_5"));
                end
                wait(actual_total==0);
            join_any
            disable r2;
        end
        forever begin
            @(posedge flag_empty_10);
            fork : r3 
                @(posedge flag_return_10);
                begin
                    repeat(200) @(posedge vif.clk);
                    `uvm_error("SCB", $sformatf("return_10 is not asserted in responds to empty_10"));
                end
                wait(actual_total==0);
            join_any
            disable r3;
        end
        forever begin
            @(posedge flag_empty_25);
            fork : r4
                @(posedge flag_return_25);
                begin
                    repeat(200) @(posedge vif.clk);
                    `uvm_error("SCB", $sformatf("return_25 is not asserted in responds to empty_25"));
                end
                wait(actual_total==0);
            join_any
            disable r4;
        end
        forever begin
            @(posedge vif.DUT_MON.buy);
            fork : buy_p
                wait(vif.DUT_MON.ok==1 && actual_total>=amo);
                begin
                    repeat(200) @(posedge vif.clk);
                    `uvm_error("SCB", $sformatf("ok is not asserted in responds to buy"));
                end
            join_any
            disable buy_p;
        end
    join
  endtask
  virtual function void write_dut_monitor(vend_seq_item trans1);
    `uvm_info(get_type_name(),$sformatf(" Printing trans received from DUT MON, \n %s",
                                          trans1.sprint()),UVM_LOW)
    flag_return_5=0;
    flag_return_10=0;
    flag_return_25=0;
    case(trans1.oper)
        vend_seq_item:: buy: begin
         actual_total=actual_total-trans1.amount;
         if(actual_total!= ref_total) `uvm_error("SCB",$sformatf("actual_total and ref_total is not matching"));
         end
         vend_seq_item::return_coin: begin
         
          case(trans1.ret_type)
              vend_seq_item::return_5 : begin actual_total-=5;   
                                              if(flag_empty_10 || flag_empty_25) 
                                                `uvm_error("SCB", $sformatf("return_5 is not asserted in responds to empty_5, empty_10=%0d empty_25=%0d",flag_empty_10,flag_empty_25));
                                              flag_empty_5=0;
                                              flag_return_5=1;
                                        end
             vend_seq_item::return_10 : begin  actual_total-=10; 
                                              if(flag_empty_5 || flag_empty_25) 
                                                `uvm_error("SCB", $sformatf("return_10 is not asserted in responds to empty_10, empty_5=%0d empty_25=%0d",flag_empty_5,flag_empty_25));
                                                flag_empty_10=0;
                                                flag_return_10=1;
         end
             vend_seq_item::return_25 : begin  actual_total-=25; 
                                              if(flag_empty_5 || flag_empty_10) 
                                                `uvm_error("SCB", $sformatf("return_25 is not asserted in responds to empty_25, empty_5=%0d empty_10=%0d",flag_empty_5,flag_empty_10));
                                                flag_empty_25=0;
                                                flag_return_25=1;
         end
     endcase
     end
     endcase
             
   if(actual_total<0) begin
     `uvm_error("SCB",$sformatf("actual_total=%0d which is negative so design is not working correctly ",actual_total))
   end
    else if(actual_total<5) actual_total=0;

  endfunction

endclass : vend_scoreboard
