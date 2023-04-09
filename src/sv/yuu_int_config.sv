`ifndef YUU_INT_CONFIG_SV
`define YUU_INT_CONFIG_SV

class yuu_int_config extends uvm_object;
  virtual yuu_int_if vif;
  uvm_event_pool events;
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  string prefix;
  protected yuu_int_severity_e m_severity[int] = '{default:POSEDGE};
  protected uvm_sequence_base m_seq_pool[int];

  `uvm_object_utils(yuu_int_config)

  extern         function                    new(string name="yuu_int_config");
  extern virtual function void               install_isr(uvm_sequence_base seq, int isr_idx, yuu_int_severity_e severity=POSEDGE);
  extern         function uvm_sequence_base  get_isr(int isr_idx);
  extern         function yuu_int_severity_e get_severity(int isr_idx);
endclass

function yuu_int_config::new(string name="yuu_int_config");
  super.new(name);

  events = new("events");
endfunction

function void yuu_int_config::install_isr(uvm_sequence_base seq, int isr_idx, yuu_int_severity_e severity=POSEDGE);
  if (isr_idx > `YUU_MAX_INT_IDX)
    `uvm_fatal("set_isr", $sformatf("Input ISR index %0d should not greater than `YUU_MAX_INT_IDX (%0d)", isr_idx, `YUU_MAX_INT_IDX))
  m_seq_pool[isr_idx] = seq;
  m_severity[isr_idx] = severity;
endfunction

function uvm_sequence_base yuu_int_config::get_isr(int isr_idx);
  if (!m_seq_pool.exists(isr_idx))
    `uvm_fatal("get_isr", $sformatf("ISR index %0d haven't set yet", isr_idx))
  return m_seq_pool[isr_idx];
endfunction

function yuu_int_severity_e yuu_int_config::get_severity(int isr_idx);
  return m_severity[isr_idx];
endfunction

`endif
