`ifndef YUU_INT_AGENT_SV
`define YUU_INT_AGENT_SV

class yuu_int_agent extends uvm_agent;
  yuu_int_config cfg;
  yuu_int_driver driver;

  `uvm_component_utils(yuu_int_agent)

  function new(string name = "yuu_int_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(yuu_int_config)::get(this, "", "cfg", cfg) && cfg == null)
      `uvm_fatal("build_phase", "Cannot get yuu_int configuration object")
    if (!uvm_config_db#(virtual yuu_int_if)::get(this, "", "vif", cfg.vif) && cfg.vif == null)
      `uvm_fatal("build_phase", "Cannot get yuu_int virtual interface handle")

    driver = yuu_int_driver::type_id::create("driver", this);
    driver.cfg = cfg;
  endfunction
endclass

`endif