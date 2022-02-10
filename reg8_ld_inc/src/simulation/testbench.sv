`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;

    `uvm_component_utils(test)

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    agent a0;
    scoreboard sb0;

    virtual function void build_phase(uvm_phase phase);
        a0 = agent::type_id::create("a0", this);
        sb0 = scoreboard::type_id::create("sb0", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);  
        a0.m0.mon_analysis_port(sb0.mon_analysis_imp);
    endfunction

endclass //env

class test extends uvm_test;

    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);        
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[TEST]", "No interface!")

        e0 = env::type_id::create("e0", this);
        g0 = env::type_id::create("g0", this);
    endfunction


    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);        

        phase.raise_objection(this);

        vif.rst_n <= 0;
        #20 vif.rst_n <= 1;

        g0.start(e0.a0.s0);

        phase.drop_objection(this);

    endtask


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
