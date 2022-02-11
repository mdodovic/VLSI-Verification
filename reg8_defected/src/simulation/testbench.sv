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
