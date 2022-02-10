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
        return $sformatf("control=%15b, serial_input_lsb=%1b, serial_input_msb=%1b, parallel_input=%8b; serial_output_lsb=%1b, serial_output_msb=%1b, parallel_output=%8b",
            control, serial_input_lsb, serial_input_msb, parallel_input, serial_output_lsb, serial_output_msb, parallel_output
        );
    endfunction

endclass //register_item

class generator extends uvm_sequence;
    
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
            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]: ", i + 1, 3), UVM_LOW)
            item.print();
            finish_item(item);
        end

        // CLEAR
        for(int i = 0; i < 1; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);
            item.randomize();
            item.control = 15'b000_0000_0000_0001;
            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [CLEAR]: ", i + 1, 1), UVM_LOW)
            item.print();
            finish_item(item);            
        end
        
        // LOAD
        for(int i = 0; i < 1; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);
            item.randomize();
            item.parallel_input = 8'hFE;
            item.control = 15'b000_0000_0000_0010;
            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [LOAD]: ", i + 1, 1), UVM_LOW)
            item.print();
            finish_item(item);
        end

        // INC
        for(int i = 0; i < 10; i++) begin
            register_item item = register_item::type_id::create("item");
            start_item(item);
            item.randomize();
            item.control = 15'b000_0000_0000_0100;
            `uvm_info("[GENERATOR]", $sformatf("Item %0d/%0d generated [INC]: ", i + 1, 10), UVM_LOW)
            item.print();
            finish_item(item);
        end


    endtask

endclass //generator extends uvm_sequence


class driver extends uvm_driver #(register_item);

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual register_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[DRIVER]", "Interface not found!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge vif.clk);
        forever begin
            register_item item;
            seq_item_port.get_next_item(item);

            `uvm_info("[DRIVER]", $sformatf("%s", item.convert2str()), UVM_LOW)

            vif.control <= item.control;
            vif.serial_input_lsb <= item.serial_input_lsb;
            vif.serial_input_msb <= item.serial_input_msb;
            vif.parallel_input <= item.parallel_input;

            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask

endclass //driver extends uvm_driver #(register_item)


class monitor extends uvm_monitor;
    
    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual register_if vif;
    uvm_analysis_port #(register_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[MONITOR]", "Interface not found!")
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
        m0 = monitor::type_id::create("m0", this);
        d0 = driver::type_id::create("d0", this);
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

    uvm_analysis_imp #(register_item, scoreboard) mon_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_imp = new("mon_analysis_imp", this);
    endfunction

    bit lsb = 1'b0;
	bit msb = 1'b0;
	bit [7:0] reg_output = 8'h00;

    virtual function void write(register_item item);
        if((item.parallel_output == reg_output) && (item.serial_output_lsb == lsb) && (item.serial_output_msb == msb))
            `uvm_info("[SCOREBOARD]", $sformatf("PASS! \n Expected output %8b != got output %8b; Expected msb %1b != got msb %1b; Expected lsb %1b != got lsb %1b; ", 
                            reg_output, item.parallel_output, msb, item.serial_output_msb, lsb, item.serial_output_lsb
                            ), UVM_LOW)
        else 
            `uvm_error("[SCOREBOARD]", $sformatf("ERROR! Expected output %8b != got output %8b; Expected msb %1b != got msb %1b; Expected lsb %1b != got lsb %1b; ", 
                reg_output, item.parallel_output, msb, item.serial_output_msb, lsb, item.serial_output_lsb
                ))

        if(item.control[0]) begin
            // CLEAR
            lsb = 1'b0;
            msb = 1'b0;
            reg_output = 8'h00;
        end else if(item.control[1]) begin
            // LOAD
            lsb = 1'b0;
            msb = 1'b0;
            reg_output = item.parallel_input;            
        end else if(item.control[2]) begin
            // INC
            if(reg_output == 8'hFF) 
                msb = 1'b1;
            else 
                msb = 1'b0;
            lsb = 1'b0;
            reg_output = reg_output + 1'b1;
        end else if(item.control[3]) begin
            // DEC
            if(reg_output == 8'h00) 
                msb = 1'b1;
            else 
                msb = 1'b0;
            lsb = 1'b0;
            reg_output = reg_output - 1'b1;
        end else if(item.control[4]) begin
            // ADD
            bit[8:0] carry_bit = 9'h000;
            for(int i = 0; i < 8; i++) begin
                if(reg_output[i] && item.parallel_input[i])
                    carry_bit[i] = 1'b1;
                else if(reg_output[i] && !item.parallel_input[i] && carry_bit[i])
                    carry_bit[i] = 1'b1;
                else if(!reg_output[i] && item.parallel_input[i] && carry_bit[i])
                    carry_bit[i] = 1'b1;
                else
                    carry_bit[i] = 1'b0;
            end

            if(carry_bit[8])
                msb = 1'b1;
            else 
                msb = 1'b0;
            lsb = 1'b0;
            reg_output = reg_output + item.parallel_input;
        end else if(item.control[5]) begin
            // SUB
            bit[8:0] signed_substraction;
            signed_substraction = reg_output - item.parallel_input;

            if(signed_substraction[8])
                msb = 1'b1;
            else 
                msb = 1'b0;
            lsb = 1'b0;
            reg_output = reg_output - item.parallel_input;
        end else if(item.control[6]) begin
            // INVERT
            msb = 1'b0;
            lsb = 1'b0;
            reg_output = ~reg_output;
        end else if(item.control[7]) begin
            // SERIAL_INPUT_LSB - SHIFT LEFT
            msb = reg_output[7];
            lsb = 1'b0;
            for(int i = 7; i >= 1; i++)
                reg_output[i] = reg_output[i - 1];
            reg_output[0] = item.serial_input_lsb;
        end else if(item.control[8]) begin
            // SERIAL_INPUT_MSB - SHIFT RIGHT
            msb = 1'b0;
            lsb = reg_output[0];
            reg_output = reg_output / 2;
            reg_output[7] = item.serial_input_msb;
        end else if(item.control[9]) begin
            // SHIFT_LOGICAL_LEFT
            bit [7:0] temp;
            msb = reg_output[7];
            lsb = 1'b0;
            temp = 8'h00;
            temp = reg_output;
            for (int i = 1; i < 8; i++) begin
                reg_output[i] = temp[i-1];
            end
            reg_output[0] = 1'b0;
        end else if(item.control[10]) begin
            // SHIFT_LOGICAL_RIGHT
            lsb = reg_output[0];
            msb = 1'b0;

            reg_output = reg_output / 2;
            reg_output[7] = 1'b0;
        end else if(item.control[11]) begin
            // SHIFT_ARITHMETIC_LEFT
            bit [7:0] temp;
            msb = reg_output[7];
            lsb = 1'b0;
            temp = 8'h00;
            temp = reg_output;
            for (int i = 1; i < 8; i++) begin
                reg_output[i] = temp[i-1];
            end
            reg_output[0] = 1'b0;
        end else if(item.control[12]) begin
            // SHIFT_ARITHMETIC_RIGHT
            bit previous_msb = reg_output[7];
            lsb = reg_output[0];
            msb = 1'b0;
            reg_output = reg_output / 2;
            reg_output[7] = previous_msb;
        end else if(item.control[13]) begin
            // ROTATE_LEFT
            msb = reg_output[7];
            lsb = 1'b0;
            reg_output = reg_output * 2;
            reg_output[0] = msb;
        end else if(item.control[14]) begin
            // ROTATE_RIGHT
            lsb = reg_output[0];
            msb = 1'b0;
            reg_output = reg_output / 2;
            reg_output[7] = lsb;

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

    virtual register_if vif;
    env e0;
    generator g0;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(virtual register_if)::get(this, "", "register_vif", vif))
            `uvm_fatal("[TEST]", "Interface not found!")
        e0 = env::type_id::create("e0", this);
        g0 = generator::type_id::create("g0");
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        vif.rst_n <= 0;
        #20 vif.rst_n <= 1;

        g0.start(e0.a0.s0);

        phase.drop_objection(this);
    endtask


endclass //test extends uvm_test

interface register_if (input bit clk);
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
        .clk(clk)
    );

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
        uvm_config_db#(virtual register_if)::set(null, "*", "register_vif", dut_if);
        run_test("test");
    end

endmodule
