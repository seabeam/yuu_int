
import uvm_pkg::*;
`include "uvm_macros.svh"

import yuu_int_pkg::*;

class test_a_item extends uvm_sequence_item;
  string s;

  `uvm_object_utils(test_a_item)

  function new(string name="test_a_item");
    super.new(name);
  endfunction
endclass

class test_a_sequence extends uvm_sequence #(test_a_item);
  `uvm_object_utils(test_a_sequence)

  function new(string name="test_a_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_create(req)
    req.s = "this is item A";
    `uvm_send(req)
  endtask
endclass

class test_a_driver extends uvm_driver #(test_a_item);
  `uvm_component_utils(test_a_driver)

  function new(string name = "test_a_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display("@%0t %s", $realtime(), req.s);
      seq_item_port.item_done();
    end
  endtask
endclass

typedef uvm_sequencer #(test_a_item) test_a_sequencer;

class test_b_item extends uvm_sequence_item;
  string s;

  `uvm_object_utils(test_b_item)

  function new(string name="test_b_item");
    super.new(name);
  endfunction
endclass

class test_b_sequence extends uvm_sequence #(test_b_item);
  `uvm_object_utils(test_b_sequence)

  function new(string name="test_b_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_create(req)
    req.s = "this is item B";
    `uvm_send(req)
  endtask
endclass

class test_b_driver extends uvm_driver #(test_b_item);
  `uvm_component_utils(test_b_driver)

  function new(string name = "test_b_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display("@%0t %s", $realtime(), req.s);
      seq_item_port.item_done();
    end
  endtask
endclass

typedef uvm_sequencer #(test_b_item) test_b_sequencer;


class test extends uvm_test;
  yuu_int_agent agent;
  yuu_int_config cfg;

  test_a_sequence a_seq;
  test_a_driver a_driver;
  test_a_sequencer a_sequencer;
  test_b_sequence b_seq;
  test_b_driver b_driver;
  test_b_sequencer b_sequencer;

  `uvm_component_utils(test)

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    cfg = yuu_int_config::type_id::create("cfg");
    agent = yuu_int_agent::type_id::create("agent", this);
    agent.cfg = cfg;

    a_seq = new("a_seq");
    a_driver = new("a_driver", this);
    a_sequencer = new("a_sequencer", this);
    a_seq.set_sequencer(a_sequencer);
    
    b_seq = new("b_seq");
    b_driver = new("b_driver", this);
    b_sequencer = new("b_sequencer", this);
    b_seq.set_sequencer(b_sequencer);

    cfg.install_isr(a_seq, 3, yuu_int_pkg::POSEDGE);
    cfg.install_isr(b_seq, 0, yuu_int_pkg::NEGEDGE);
  endfunction

  function void connect_phase(uvm_phase phase);
    a_driver.seq_item_port.connect(a_sequencer.seq_item_export);
    b_driver.seq_item_port.connect(b_sequencer.seq_item_export);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #1000;
    phase.drop_objection(this);
  endtask
endclass

module top;
  logic clk;

  yuu_int_if pif(clk);

  initial begin
    uvm_config_db#(virtual yuu_int_if)::set(null, "uvm_test_top.agent", "vif", pif);
    run_test("test");
  end

  initial begin
    clk = 0;
    pif.interrupt = 32'h0;
    #100;
    pif.interrupt = 32'h9;
    #100;
    pif.interrupt = 32'h0;
    #100;
    pif.interrupt = 32'h1;
    #200;
  end

  always #5 clk = ~clk;
endmodule
