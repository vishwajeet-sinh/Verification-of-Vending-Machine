import uvm_pkg::*;

`include "interface.sv"
`include "pkg.sv"
//`include "vend/vend.sv"
`include "vend/vend10.svp"
//include "vend/vend2.svp"
//include "vend/vend3.svp"
//include "vend4.svp"
//include "vend5.svp"
//include "vend6.svp"
//include "vend7.svp"
//include "vend8.svp"
//include "vend9.svp"
//include "vend10.svp"
//include "trans.sv"
//include "sequence.sv"
//include "driver.sv"
//include "monitor.sv"
//include "agent.sv"
//include "scoreboard.sv"
//include "env.sv"
//include "test.sv"
import vend_pkg::*;
module top;

bit clk;
always #5 clk=~clk;

vend_if if1(clk);

vend a1(clk,if1.rst,if1.detect_5 ,if1.detect_10,if1.detect_25 ,if1.amount ,if1.buy ,if1.return_coins 
,if1.empty_5 ,if1.empty_10 ,if1.empty_25 ,if1.ok ,if1.return_5 ,if1.return_10 ,if1.return_25);
initial begin
    $display("running test");
    run_test("test");
end

initial begin
    uvm_config_db#(virtual vend_if)::set(uvm_root::get(),"*","vif",if1);
    $dumpfile("dump.vcd"); 
    $dumpvars;
end
endmodule
