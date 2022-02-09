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

// Generator
class generator extends uvm_sequence;

	`uvm_object_utils(generator)

	function new(string name="generator");
		super.new(name);
	endfunction

	int num = 20;

	virtual task body();
		for(int i = 0; i < num; i++) begin
			reg8_item item = reg8_item::type_id::create("item");
			start_item(item);

			item.randomize();
			`uvm_info("Generator", $sformatf("Item %0d/%0d created", i + 1, num), UVM_LOW)
			item.print();

			finish_item(item);			
		end
	endtask

endclass

// Driver
class driver extends uvm_driver #(reg8_item);

	`uvm_component_utils(driver)

	function new(string name = "driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual reg8_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual reg8_if)::get(this, "", "reg8_vif", vif))
			`uvm_fatal("Driver", "No interface,")
	endfunction

	virtual task run_phase(uvm_phase phase);

		super.run_phase(phase);

		forever begin
			reg8_item item;
			seq_item_port.get_next_item(item);

			`uvm_info("Driver", $sformatf("%s", item.my_print()), UVM_LOW)			

			vif.ld <= item.ld;
			vif.inc <= item.inc;
			vif.in <= item.in;

			@(posedge vif.clk);
			seq_item_port.item_done();		
		end

	endtask

endclass

// Monitor
class monitor extends uvm_monitor;

	`uvm_component_utils(monitor)

	function new(string name = "monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		@(posedge vif.clk);
		forever begin
			reg8_item item = reg8_item::type_id::create("item");
			@(posedge vif.clk);
			
			item.ld = vif.ld;
			item.inc = vif.inc;
			item.in = vif.in;
			item.out = vif.out;
			
			`uvm_info("Monitor", $sformatf("%s", item.my_print()), UVM_LOW)

			mon_analysis_port.write(item);
		end
	endfunction

endclass