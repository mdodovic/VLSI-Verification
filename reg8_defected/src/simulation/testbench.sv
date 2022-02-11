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
    `uvm_object_utils_end

    function new(string name = "register_item");
        super.new(name);
    endfunction //new()

    virtual function string convert2str();
        return $sformatf("Item: control = %15b, input_lsb = %1b, input_msb = %1b, parallel_input = %8b, output_lsb = %1b, input_msb = %1b, parallel_input = %8b",
            control, serial_input_lsb, serial_input_msb, parallel_input, serial_output_lsb, serial_output_msb, parallel_output
        );
    endfunction

endclass //register_item extends uvm_sequence_item

class generator extends uvm_generator;

    `uvm_object_utils(generator)

    function new(string name = "generator");
        super.new(name);
    endfunction //new()

    virtual task body();

        // LOAD
        for(int i = 0; i < 3; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);

            item.randomize();
            item.control = 15'b000_0000_0000_0010;

            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d created [LOAD]"), UVM_LOW)
            item.print();

            finish_item(item);
        end

    endtask

endclass //generator extends uvm_generator

class driver extends uvm_driver #(register_item);

    `uvm_component_utils(driver)

    function new(string name = "driver");
        super.new(name);
    endfunction //new()

    virtual register_if vif;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[DRIVER]", "No interface.")
    endfunction 

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge vif.clk);
        forever begin
            register_item item;
            seq_item_port.get_next_item(item)

            vif.control <= item.control;
            vif.serial_input_lsb <= item.serial_input_lsb;
            vif.serial_input_msb <= item.serial_input_msb;
            vif.parallel_input <= item.parallel_input;

            `uvm_info("[DRIVER]", $sformatf("%s", item.convert2str()), UVM_LOW)

            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask

endclass //driver extends uvm_driver #(register_item)

class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    function new(string name = "monitor");
        super.new(name);
    endfunction //new()

    virtual register_if vif;
    uvm_analysis_port #(register_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[MONITOR]", "No interface.")
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction 

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge vif.clk);
        forever begin
            register_item item = register_item::type_id::create("item");
            @(posedge vif.clk);

            item.control = vif.control;
            item.serial_input_lsb = vif.serial_input_lsb;
            item.serial_input_msb = vif.serial_input_msb;
            item.parallel_input = vif.parallel_input;
            item.serial_output_lsb = vif.serial_output_lsb;
	        item.serial_output_msb = vif.serial_output_msb;
	        item.parallel_output = vif.parallel_output;

            `uvm_info("[MONITOR]", $sformatf("%s", item.convert2str), UVM_LOW)

            mon_analysis_port.write(item);
        end

    endtask

endclass //monitor extends uvm_monitor 

class agent extends uvm_agent;

    `uvm_component_utils(agent)

    function new(string name = "agent");
        super.new(name);
    endfunction //new()

    driver d0;
    monitor m0;
    uvm_sequencer#(register_item) s0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d0 = driver::type_id::create("d0", this);
        m0 = monitor::type_id::create("m0", this);
        s0 = uvm_sequencer#(register_item)::type_id::create("s0", this);
    endfunction 

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d0.seq_item_port.connect(s0.seq_item_export);
    endfunction

endclass //agent extends uvm_agent


interface register_if (
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
