`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;

    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

endclass //test


interface register_if(
    input bit clk;
);
    logic rst_n,
    logic ld,
    logic inc,
    logic [7:0] in,
    logic [7:0] out
endinterface //register_if

module testbench;
    
    reg clk;

    register_if dut_if(
       .clk (clk)
    );

    reg8 dut_inst(
        .clk(clk),
        .rst_n(dut_if.rst_n),
        .ld(dut_if.ld),
        .inc(dut_if.inc),
        .in(dut_if.in),
        .out(dut_if.out)
    );

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk
        end            
    end

    initial begin
        uvm_config_db#(virtual register_if)::set(null, "*", "register_vif", dut_if);
        run_test("test");
    end

endmodule
