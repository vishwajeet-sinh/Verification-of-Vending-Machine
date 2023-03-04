class vend_sequence extends uvm_sequence#(vend_seq_item);

  `uvm_object_utils(vend_sequence)
  
  function new(string name = "vend_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
      req = vend_seq_item::type_id::create("req");
      
      start_item(req);
      assert(req.randomize() with {oper==send_5;emp_type==no_empty;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==send_10;emp_type==no_empty;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==send_25;emp_type==no_empty;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==send_10;emp_type==no_empty;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==send_25;emp_type==no_empty;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==buy;emp_type==no_empty;});
      finish_item(req);

      start_item(req);
      assert(req.randomize() with {oper==return_coin;emp_type==empty_10;});
      finish_item(req);
      
      start_item(req);
      assert(req.randomize() with {oper==return_coin;emp_type==empty_5;});
      finish_item(req);


      start_item(req);
      assert(req.randomize() with {oper==return_coin;emp_type==no_empty;});
      finish_item(req);
      
      #2000;

  endtask
endclass

class reset_seq extends uvm_sequence#(vend_seq_item);
  
  bit [3:0] reset_duration;

  // Virtual Interface
  virtual vend_if vif;

  `uvm_object_utils(reset_seq)

  function new(string name = "reset_seq");
    super.new(name);
  endfunction
  
  virtual task body();
     void'(randomize(reset_duration));
     vif.TB.rst <= 1'b0;
     #reset_duration;
     vif.TB.rst <=1'b1;
     #reset_duration;
     vif.TB.rst <=1'b0;

  endtask
endclass
