`include "uvm_macros.svh"
import uvm_pkg::*;

class test;

    `uvm_component_utils(test);

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual register_if)::get(this, "", "register_if", vif))
            `uvm_fatal("[TEST]", "Could not get virtual interface!")    

        e0 = env::type_id::create("e0", this);
        g0 = generator::type_id::create("g0", this);                
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();        
    endfunction

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