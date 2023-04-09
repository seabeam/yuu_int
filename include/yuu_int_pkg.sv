`ifndef YUU_INT_PKG_SV
`define YUU_INT_PKG_SV

`include "yuu_int_defines.svh"
`include "yuu_int_if.sv"

package yuu_int_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "yuu_int_type.sv"
  `include "yuu_int_config.sv"
  `include "yuu_int_driver.sv"
  `include "yuu_int_agent.sv"
endpackage

`endif