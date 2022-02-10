`include "uvm_macros.svh"
import uvm_pkg::*;

class register_item extends uvm_sequence_item;

    rand bit ld;
    rand bit inc;
    rand bit [7:0] in;

    bit [7:0] out;

    `uvm_object_utils_begin(register_item)

        `uvm_field_int(ld, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(inc, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(in, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(out, UVM_NOPRINT)
        
    `uvm_object_utils_end


    function new(string name = "register_item");
        super.new(name);        
    endfunction //new()

    virtual function string convert2str();
        return $sformatf("ld = %1b, inc = %1b, in = %8b, out = %8b", ld, inc, in, out);
    endfunction

endclass //register_item

class driver extends uvm_driver#(register_item);
    
    `uvm_component_utils(test)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    virtual register_if vif;

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);  
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[DRIVER]", "No interface!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);  

        @(posedge vif.clk);

        forever begin
            register_item item;
            seq_item_port.get_next_item(item);
            `uvm_info("[DRIVER]", $sformatf("%s", item.convert2str()), UVM_LOW)

            vif.ld <= item.ld;
            vif.inc <= item.inc;
            vif.in <= item.in;
            
            @(posedge vid.clk);
            seq_item_port.item_done();
        end

    endtask

endclass //driver

class monitor extends uvm_monitor;
    
    `uvm_component_utils(test)

    function new(string name = "montior", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    virtual register_if vif;
    uvm_analyser_port#(register_item) mon_analyser_port;

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);  
    if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[MONITOR]", "No interface!")
        mon_analyser_port = new("mon_analyser_port", this);

    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);  
        @(posedge vif.clk)
        forever begin
            register_item item = register_item::type_id::create("item");
            @(posedge vif.clk)

            item.ld = vif.ld;
            item.inc = vif.inc;
            item.in = vif.in;
            item.out = vif.out;

            `uvm_info("[MONITOR]", $sformatf("%s", item.convert2str()), UVM_LOW)

            mon_analyser_port.write(item);

        end
    endtask;

endclass //monitor extends uvm_monitor


class agent extends uvm_agent;

    `uvm_component_utils(test)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    driver d0;
    monitor m0;
    uvm_sequencer#(register_item) s0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);  
        d0 = driber::type_id::create("d0", this);
        m0 = monitor::type_id::create("m0", this);
        s0 = uvm_sequencer#(register_item)::type_id::create("s0", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);  
        d0.seq_item_port.connect(s0.seq_item_export);
    endfunction

endclass //agent

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(test)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    uvm_analysis_imp#(register_item, scoreboard) mon_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);  
        mon_analysis_imp = new("mon_analysis_imp", this);
    endfunction

    bit [7:0] reg_out = 8'h00;

    virtual function write(register_item item);
        if(reg_out == item.out)
            `uvm_info("[SCOREBOARD]", $sformatf("USPEH!"), UVM_LOW)
        else 
            `uvm_error("[SCOREBOARD]", $sformatf("GRESKA! Ocekivani %8b dobijeni %8b", reg_out, item.out), UVM_LOW)

        if(item.ld)
            reg_out = item.in;
        else if(item.inc)
            reg_out = reg_out + 1'b1;   

    endfunction 

endclass //scoreboard


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
        a0.m0.mon_analysis_port.connect(sb0.mon_analysis_imp);
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
