`include "uvm_macros.svh"
import uvm_pkg::*;

// Item
class reg8_item extends uvm_sequence_item;

	rand bit ld;
	rand bit inc;
	rand bit [7:0] in;
	bit [7:0] out;

	`uvm_object_utils_begin(reg8_item)
		`uvm_field_int(ld, UVM_DEFAULT)
		`uvm_field_int(inc, UVM_DEFAULT | UVM_BIN)
		`uvm_field_int(in, UVM_ALL_ON)
		`uvm_field_int(out, UVM_NO_PRINT)
	`uvm_object_utils_end

	function new(string name="reg8_item");
		super.new(name);
	endfunction

	virtual function string my_print();
		return $sformatf(
			"ld = %1b inc = %1b in = %8b out = %8b",
			ld, inc, in, out
		);
	endfunction

endclass
