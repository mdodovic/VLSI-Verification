`include "uvm_macros.svh"
import uvm_pkg::*;

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

endmodule