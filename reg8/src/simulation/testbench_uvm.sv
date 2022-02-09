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
		`uvm_field_int(out, UVM_NOPRINT)
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

	virtual reg8_if vif;
	uvm_analysis_port #(reg8_item) mon_analysis_port;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(virtual reg8_if)::get(this, "", "reg8_vif", vif))
			`uvm_fatal("Monitor", "No interface.")
		mon_analysis_port = new("mon_analysis_port", this);

	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);

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
	endtask

endclass

// Agent
class agent extends uvm_agent;

	`uvm_component_utils(agent);

	function new(string name = "agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	driver d0;
	monitor m0;
	uvm_sequencer #(reg8_item) s0;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		d0 = driver::type_id::create("d0", this);
		m0 = monitor::type_id::create("m0", this);
		s0 = uvm_sequencer#(reg8_item)::type_id::create("d0", this);
	endfunction 

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d0.seq_item.port.connect(s0.seq_item_export);
	endfunction

endclass

// Scoreboard
class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	uvm_analysis_imp #(reg8_item, scoreboard) mon_analysis_imp;

	virtual function void build_phase(uvm_phase phase);

		super.build_phase(phase);
		mon_analysis_imp = new("mon_analysis_imp", this);
	endfunction

	bit [7:0] reg8 = 8'h00;

	virtual function write(reg8_item item);
		
		if(reg8 == item.out)
			`uvm_info("Scoreboard", $sformatf("PASS!"), UVM_LOW)
		else
			`uvm_error("Scoreboard", $sformatf("FAIL! expected = %8b, got = %8b", reg8, item.out))

		if(item.ld) 
			reg8 = item.in;
		else if(item.inc)	
			reg8 = reg8 + 8'h01;

	endfunction

endclass

// Environment 
class env extends uvm_env;

	`uvm_component_utils(env)

	function new(string name = "env", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

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


endclass

// Test 
class test extends uvm_test;

	`uvm_component_utils(test);

	function new(string name = "test", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	virtual reg8_if vif;

	env e0;
	generator g0;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual reg8_if)::get(this, "", "reg8_vif", vif))
			`uvm_fatal("Test", "No interface.")
		
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
endclass

interface reg8_if (
	input bit clk
);
	logic rst_n;
	logic ld;
	logic inc;
	logic [7:0] in;
	logic [7:0] out;
endinterface


// Testbench
module testbench_uvm;

	reg clk;

	reg8_if dut_if(
		.clk(clk)
	);
	reg8 dut(
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
			#10 clk = ~clk;
		end
	end

	initial begin
		uvm_config_db#(virtual reg8_if)::set(null, "*", "reg8_vif", dut_if);
		run_test("test");
	end

endmodule
