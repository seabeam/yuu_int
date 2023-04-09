# YUU UVM INTERRUPT VIP

This is a interrupt VIP which implemented with UVM.

## Getting started
1. Create ISR sequence and sequencer handler(s) for your interrupt(s). All types of interrupt sequence are supported.
```systemverilog
example_a_sequence seq_a = example_a_sequence::type_id::create("seq_a");
example_b_sequence seq_b = example_b_sequence::type_id::create("seq_b");

example_a_sequencer sqr_a = example_a_sequencer::type_id::create("sqr_a", this);
example_b_sequencer sqr_b = example_b_sequencer::type_id::create("sqr_b", this);
```

2. Register the sequencer to corresponding sequence by set_sequencer() method. Virtual sequencers is also supported.
```systemverilog
seq_a.set_sequencer(sqr_a);
seq_b.set_sequencer(sqr_b);
```

3. Create yuu_int_config configuration object and register the ISR with INT number and sensitivity.
```systemverilog
yuu_int_config cfg = yuu_int_config::type_id::create("cfg");

cfg.install_isr(seq_a, 0, yuu_int_pkg::POSEDGE);
cfg.install_isr(seq_b, 3, yuu_int_pkg::NEGEDGE);
```

4. Connect your DUT interrupt signal to yuu_int_if interrupt signal.
```systemverilog
yuu_int_if int_if();

assign int_if.interrupt[0] = DUT.interrupt_a;
assign int_if.interrupt[3] = DUT.interrupt_b;
```

**Note**

The interrupt connction must be the same as the corresponding ISR registered to configuration object.

## Example

An example included in sim/top.sv.

You can run ``make`` to have a local simulation with VCS