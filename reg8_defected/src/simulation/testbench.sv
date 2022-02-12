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
        return $sformatf("Item: control = %15b, input_msb = %1b, input = %8b, input_lsb = %1b, output_msb = %1b, output = %8b, output_lsb = %1b",
            control, serial_input_msb, parallel_input, serial_input_lsb, serial_output_msb, parallel_output, serial_output_lsb);
    endfunction

endclass //register_item extends uvm_sequence_item

class generator extends uvm_sequence;

    `uvm_object_utils(generator)

    function new(string name = "generator");
        super.new(name);
    endfunction //new()

    virtual task body();

        // // LOAD
        // for(int i = 0; i < 3; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 3), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 2; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 2), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // CLEAN
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0001;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [CLEAN]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // INC
        // for(int i = 0; i < 10; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0100;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [INC]", i + 1, 10), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // DEC
        // for(int i = 0; i < 10; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_1000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [DEC]", i + 1, 10), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // ADD
        // for(int i = 0; i < 10; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0001_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [ADD]", i + 1, 10), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // SUB
        // for(int i = 0; i < 10; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0010_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SUB]", i + 1, 10), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // empty clock
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [NOTHING]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // INVERT
        // for(int i = 0; i < 20; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0100_0000;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [INVERT]", i + 1, 20), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;
        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // serial input lsb
        // for(int i = 0; i < 20; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_1000_0000;
        //     item.serial_input_lsb = 1'b1;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SERIAL INPUT LSB]", i + 1, 20), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // serial input lsb
        // for(int i = 0; i < 20; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_1000_0000;
        //     item.serial_input_lsb = 1'b0;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SERIAL INPUT LSB]", i + 1, 20), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;
        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // serial input msb
        // for(int i = 0; i < 20; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0001_0000_0000;
        //     item.serial_input_msb = 1'b1;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SERIAL INPUT MSB]", i + 1, 20), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // LOAD
        // for(int i = 0; i < 1; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0000_0000_0010;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // // serial input msb
        // for(int i = 0; i < 20; i++) begin
        //     register_item item = register_item::type_id::create("item");
        //     start_item(item);

        //     item.randomize();
        //     item.control = 15'b000_0001_0000_0000;
        //     item.serial_input_lsb = 1'b0;

        //     `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SERIAL INPUT MSB]", i + 1, 20), UVM_LOW)
        //     item.print();

        //     finish_item(item);
        // end

        // LOAD
        for(int i = 0; i < 1; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);

            item.randomize();
            item.control = 15'b000_0000_0000_0010;

            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]", i + 1, 1), UVM_LOW)
            item.print();

            finish_item(item);
        end

        // shift logical left
        for(int i = 0; i < 20; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);

            item.randomize();
            item.control = 15'b000_0010_0000_0000;

            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [SHIFT LOGICAL LEFT]", i + 1, 20), UVM_LOW)
            item.print();

            finish_item(item);
        end


    endtask

endclass //generator extends uvm_sequence

class driver extends uvm_driver#(register_item);

    `uvm_component_utils(driver)

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

            vif.control <= item.control;
            vif.serial_input_lsb <= item.serial_input_lsb;
            vif.serial_input_msb <= item.serial_input_msb;
            vif.parallel_input <= item.parallel_input;
            `uvm_info("[DRIVER]", $sformatf("%s", item.convert2str()), UVM_LOW)

            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask

endclass //driver extends uvm_driver#(register_item)    

class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual register_if vif;
    uvm_analysis_port#(register_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[MONITOR]", "No interface!")
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
            `uvm_info("[MONITOR]", $sformatf("%s", item.convert2str()), UVM_LOW)

            mon_analysis_port.write(item);
        end
    endtask

endclass //monitor extends uvm_monitor

class agent extends uvm_agent;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
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

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    uvm_analysis_imp#(register_item, scoreboard) mon_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_imp = new("mon_analysis_imp", this);
    endfunction

    bit msb = 1'b0;
    bit lsb = 1'b0;
    bit [7:0] reg_output = 8'h00;

    virtual function void write(register_item item);
        if((msb == item.serial_output_msb) && (reg_output == item.parallel_output) && (lsb == item.serial_output_lsb))
            `uvm_info("[SCOREBOARD]", $sformatf("PASS!\n expect {msb = %1b, output = %8b, lsb = %1b}\n == got {msb = %1b, output = %8b, lsb = %1b} ",
                msb, reg_output, lsb, item.serial_output_msb, item.parallel_output, item.serial_output_lsb), UVM_LOW)
        else
            `uvm_error("[SCOREBOARD]", $sformatf("FAIL!\n expect {msb = %1b, output = %8b, lsb = %1b}\n == got {msb = %1b, output = %8b, lsb = %1b} ",
                msb, reg_output, lsb, item.serial_output_msb, item.parallel_output, item.serial_output_lsb))            

        msb = 1'b0;
        lsb = 1'b0;

        if(item.control[0]) begin
            // clear
            reg_output = 8'h00;
        end else if(item.control[1]) begin
            // load
            reg_output = item.parallel_input;
        end else if(item.control[2]) begin
            // inc
            {msb, reg_output} = reg_output + 1'b1;
        end else if(item.control[3]) begin
            // dec
            {msb, reg_output} = reg_output - 1'b1;
        end else if(item.control[4]) begin
            // add
            {msb, reg_output} = reg_output + item.parallel_input;
        end else if(item.control[5]) begin
            // sub
            {msb, reg_output} = reg_output - item.parallel_input;
        end else if(item.control[6]) begin
            // invert
            reg_output = reg_output ^ 8'hFF;
        end else if(item.control[7]) begin
            // serial_input_lsb
            {msb, reg_output} = {reg_output, item.serial_input_lsb};
        end else if(item.control[8]) begin
            // serial_input_msb
            {reg_output, lsb} = {item.serial_input_msb, reg_output};
        end else if(item.control[9]) begin
            // shift logical left
            {msb, reg_output} = {reg_output, 1'b0};
        end else if(item.control[10]) begin
            // shift logical right
            {reg_output, lsb} = {1'b0, reg_output};
        end else if(item.control[11]) begin
            // shift arithmetic left
            {msb, reg_output} = {reg_output, 1'b0};
        end else if(item.control[12]) begin
            // shift arithmetic right
            {reg_output, lsb} = {reg_output[7], reg_output};
        end else if(item.control[13]) begin
            // rotate left
            {msb, reg_output} = {reg_output, reg_output[7]};
        end else if(item.control[14]) begin
            // rotate right
            {reg_output, lsb} = {reg_output[0], reg_output};
        end   

    endfunction

endclass //scoreboard extends uvm_scoreboard

class env extends uvm_env;

    `uvm_component_utils(env)

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

endclass //env extends uvm_env

class test extends uvm_test;

    `uvm_component_utils(test)

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    env e0;
    generator g0;
    virtual register_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[TEST]", "No interface!")
        e0 = env::type_id::create("e0", this);
        g0 = generator::type_id::create("g0", this);
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
    endtask

endclass //test extends uvm_test

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
    
    register_if dut_if(
        .clk (clk)
    );

    register dut_inst(
        .clk (clk),
        .rst_n (dut_if.rst_n),
        .control (dut_if.control),
        .serial_input_lsb (dut_if.serial_input_lsb),
        .serial_input_msb (dut_if.serial_input_msb),
        .parallel_input (dut_if.parallel_input),
        .serial_output_lsb (dut_if.serial_output_lsb),
        .serial_output_msb (dut_if.serial_output_msb),
        .parallel_output (dut_if.parallel_output)
    );

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        uvm_config_db#(virtual register_if)::set(null, "*", "register_vif", dut_if);
        run_test("test");
    end

endmodule
