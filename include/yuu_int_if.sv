`ifndef YUU_INT_IF_SV
`define YUU_INT_IF_SV

interface yuu_int_if(input clk);
  logic[`YUU_MAX_INT_IDX:0] interrupt;

  clocking drv_cb @(posedge clk);
  endclocking
endinterface

`endif