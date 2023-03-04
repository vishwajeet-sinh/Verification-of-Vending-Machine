class vend_seq_item extends uvm_sequence_item; 
 
//data and control fields
typedef enum {send_5,send_10,send_25,return_coin,buy} oper_e;
typedef enum {empty_25,empty_10,empty_5,no_empty} empty_e;
typedef enum {return_25,return_10,return_5,no_return} return_e;
rand oper_e oper;
rand empty_e emp_type;
bit [8:0] amount;
rand bit [16:0] del;
return_e ret_type;
 
constraint del_c { if(oper==send_5 || oper==send_10 || oper==send_25 || oper == buy) del inside {[30:50]};
                    else del inside {[2000:3000]};};

function void post_randomize();
    if(!$value$plusargs("AMOUNT=%0d",amount))
        amount=50;
endfunction
`uvm_object_utils_begin(vend_seq_item)
  `uvm_field_int(amount,UVM_ALL_ON )
  `uvm_field_int(del,UVM_ALL_ON )
  `uvm_field_enum(oper_e,oper,UVM_ALL_ON )
  `uvm_field_enum(empty_e,emp_type,UVM_ALL_ON )
  `uvm_field_enum(return_e,ret_type,UVM_ALL_ON )
`uvm_object_utils_end
  
  //Constructor
  function new(string name = "vend_seq_item");
    super.new(name);
  endfunction
  
endclass
