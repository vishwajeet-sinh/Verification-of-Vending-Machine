interface vend_if(input clk);

bit rst;
bit detect_5,detect_10,detect_25,
 buy ,return_coins, empty_5 ,empty_10 , empty_25 , ok , return_5 
, return_10 ,return_25;

bit [8:0] amount;
bit [8:0] total;

modport TB(input clk,ok,return_25,return_10,return_5,output detect_5,detect_10,detect_25,buy,return_coins,amount,empty_5,empty_10,empty_25,rst);
modport MONITOR(input clk,rst,ok,return_25,return_10,return_5, detect_5,detect_10,detect_25,buy,return_coins,amount,empty_5,empty_10,empty_25);
modport DUT_MON(input clk,rst,ok,return_25,return_10,return_5,return_coins,amount,buy);


endinterface
