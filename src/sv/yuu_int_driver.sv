`ifndef YUU_INT_DRIVER_SV
`define YUU_INT_DRIVER_SV

class yuu_int_driver extends uvm_driver #(uvm_sequence_item);
  yuu_int_config cfg;
  uvm_event_pool events;
  virtual yuu_int_if vif;

  protected semaphore m_lock[];

  `uvm_component_utils(yuu_int_driver)

  extern function      new(string name, uvm_component parent);
  extern function void connect_phase(uvm_phase phase);
  extern task          run_phase(uvm_phase phase);

  extern task          detect_and_proc(int idx);
  extern task          isr_proc(int idx);
endclass

function yuu_int_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_int_driver::connect_phase(uvm_phase phase);
  vif = cfg.vif;
  events = cfg.events;
endfunction

task yuu_int_driver::run_phase(uvm_phase phase);
  m_lock = new[`YUU_MAX_INT_IDX+1];
  foreach (m_lock[i])
    m_lock[i] = new(1);

  for (int i = 0; i<=`YUU_MAX_INT_IDX; i++) begin
    automatic int j = i;
    fork
      detect_and_proc(j);
    join_none
  end
endtask

task yuu_int_driver::detect_and_proc(int idx);
  cfg.get_severity(idx);

  forever begin
    yuu_int_severity_e severity = cfg.get_severity(idx);

    m_lock[idx].get();
    @(vif.drv_cb);
    if (severity == POSEDGE)
      @(posedge vif.interrupt[idx]);
    else if (severity == NEGEDGE)
      @(negedge vif.interrupt[idx]);
    else
      @(vif.interrupt[idx]);
    isr_proc(idx);
    m_lock[idx].put();
  end
endtask

task yuu_int_driver::isr_proc(int idx);
  if (cfg.is_active == UVM_ACTIVE) begin
    uvm_sequence_base seq = cfg.get_isr(idx);
    uvm_sequencer_base sqr = seq.get_sequencer();

    seq.start(sqr);
  end
  begin
    uvm_event done = events.get($sformatf("%sisr%0d_done", cfg.prefix, idx));
    done.trigger();
  end
endtask

`endif
