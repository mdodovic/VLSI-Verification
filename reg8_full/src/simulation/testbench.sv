`include "uvm_macros.svh"
import uvm_pkg::*;

class register_item extends uvm_sequence_item;

	rand bit [14:0] control;
	rand bit serial_input_lsb;
	rand bit serial_input_msb;
	rand bit [7:0] parallel_input;
	bit serial_output_lsb;
	bit serial_output_msb;
	bit [7:0] parallel_output;

    `uvm_object_utils_begin(register_item)

        `uvm_field_int(control, UVM_DEFAULT | UVM_BIN)
        `uvm_field_int(serial_input_lsb, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(serial_input_msb, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(parallel_input, UVM_ALL_ON | UVM_BIN)
        `uvm_field_int(serial_output_lsb, UVM_NOPRINT)
        `uvm_field_int(serial_output_msb, UVM_NOPRINT)
        `uvm_field_int(parallel_output, UVM_NOPRINT)

    `uvm_object_end


    function new(string name = "register_item");
        super.new(name);
    endfunction //new()

    virtual function string convert2str();
        return $sformatf("control = %15b serial_input_lsb = %1b serial_input_msb = %1b parallel_input = %8b serial_output_lsb = %1b serial_output_msb = %1b parallel_output = %8b",
            control, serial_input_lsb, serial_input_msb, parallel_input, serial_output_lsb, serial_output_msb, parallel_output
        );
    endfunction


endclass //register_item


class driver extends uvm_driver;

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    

endclass //driver

class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual register_if vif;
    uvm_analysis_port #(register_item) mon_analysis_port;

    virtual function build_phase(phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_if", vif))
            `uvm_fatal("[MONITOR]", "Could not get virtual interface!")    

        mon_analysis_port = new("mon_analysis_port", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge vif.clk)
        forever begin
            register_item item = register_item::type_ide::create("item");
            @(posedge vif.clk)

            item.control = vif.control;
            item.serial_input_lsb = vif.serial_input_lsb;
            item.serial_input_msb = vif.serial_input_msb;
            item.parallel_input = vif.parallel_input;
            item.serial_output_lsb = vif.serial_output_lsb;
            item.serial_output_msb = vif.serial_output_msb;
            item.parallel_output = vif.parallel_output;
            `uvm_info("[MONITOR]", $sformatf("%s", item.convert2str()), UVM_LOW)

            mon_analysis_port.write(item);            

        end
    endtask

    
endclass //monitor


class agent extends uvm_agent;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    monitor m0;
    driver d0;
    uvm_sequencer #(register_item) s0;

    virtual function build_phase(phase);
        super.build_phase(phase);
        m0 = monitor::type_id::create("m0", this);
        d0 = driver::type_id::create("d0", this);
        s0 = uvm_sequencer#(register_item)::type_id::create("s0", this);
    endfunction

    virtual function connect_phase(phase);
        super.connect_phase(phase);
        d0.seq_item_port.connect(s0.seq_item_export);
    endfunction

endclass //agent

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
    
    uvm_analysis_imp #(register_item, scoreboard) mon_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_imp = new("mon_analysis_imp", this);
    endfunction

    bit [7:0] reg_out = 8'h00;

    virtual function write(register_item item);

        if((reg_out == item.parallel_output))
            `uvm_info("[SCOREBOARD]", $sformatf("USPEH!"), UVM_LOW)
        else 
            `uvm_error("[SCOREBOARD]", $sformatf("NEUSPEH! Ocekivan out: %8b dobijen out: %8b", reg_out, item.parallel_output))
        
        if(item.control[1]) begin
            reg_out = item.parallel_input;
        end else if(item.control[0]) begin
            reg_out = 8'h00;
        end        

    endfunction

endclass //scoreboard

class evn extends uvm_env;

    `uvm_component_utils(env);

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
    
    agent a0;
    scoreboard sb0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a0 = agent::type_id::create("a0", this);
        sb0 = scoreboard::type_id::create("sb0", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a0.m0.mon_analysis_port.connect(sb0.mon_analysis_imp);
    endfunction

endclass //evn


class test extends uvm_test;

    `uvm_component_utils(test);

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_if", vif))
            `uvm_fatal("[TEST]", "Could not get virtual interface!")    

        e0 = env::type_id::create("e0", this);
        g0 = generator::type_id::create("g0");                
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();        
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        vif.rst_n <= 1'b0;
        #20 vif.rst_n <= 1'b1;

        g0.start(e0.a0.s0);

        phase.drop_objection(this);        
    endtask //run_phase    

endclass //test

interface register_if(
    input bit clk
);
	logic rst_n;
	logic [14:0] control;
	logic serial_input_lsb;
	logic serial_input_msb;
	logic [7:0] parallel_input;
	logic serial_output_lsb;
	logic serial_output_msb;
	logic [7:0] parallel_output;

endinterface //register_if

module testbench;
    
    reg clk;

    register_if dut_if (
        .clk(clk);
    )
    
    dut dut_inst (
        .clk(clk),
        .rst_n(dut_if.rst_n),
        .control(dut_if.control),
        .serial_input_lsb(dut_if.serial_input_lsb),
        .serial_input_msb(dut_if.serial_input_msb),
        .parallel_input(dut_if.parallel_input),
        .serial_output_lsb(dut_if.serial_output_lsb),
        .serial_output_msb(dut_if.serial_output_msb),
        .parallel_output(dut_if.parallel_output)
    );

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        uvm_config_db#(virtual register_if)::set(null, "*", "register_if", register_if);
        run_test("test");
    end

endmodule