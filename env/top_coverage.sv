`ifndef TOP_COVERAGE_SV
`define TOP_COVERAGE_SV

class top_coverage extends uvm_component;

  `uvm_component_utils(top_coverage)

  `uvm_analysis_imp_decl(_port_a)
  uvm_analysis_imp_port_a #(gpio_uvc_sequence_item, top_coverage) port_a_imp_export;

  `uvm_analysis_imp_decl(_port_b)
  uvm_analysis_imp_port_b #(gpio_uvc_sequence_item, top_coverage) port_b_imp_export;

  `uvm_analysis_imp_decl(_port_c)
  uvm_analysis_imp_port_c #(gpio_uvc_sequence_item, top_coverage) port_c_imp_export;



  // Queue to store data
  gpio_uvc_sequence_item m_trans_a;
  gpio_uvc_sequence_item m_trans_b;
  gpio_uvc_sequence_item m_trans_c;

  
  // Covergroups
covergroup m_cov;
  cp_gpio_a: coverpoint m_trans_a.m_gpio_pin{bins gpio_bins_a[] = {[0:10]};}
  cp_gpio_b: coverpoint m_trans_b.m_gpio_pin{bins gpio_bins_b[] = {[0:10]};}
  cp_gpio_c: coverpoint m_trans_c.m_gpio_pin{bins gpio_bins_c[] = {[0:10]};}
  //cp_cross : cross cp_gpio_a, cp_gpio_b;

endgroup


  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
    extern function void write_port_a(input gpio_uvc_sequence_item t);
  extern function void write_port_b(input gpio_uvc_sequence_item t);
  extern function void write_port_c(input gpio_uvc_sequence_item t);


endclass : top_coverage


function top_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_trans_a = gpio_uvc_sequence_item::type_id::create("m_trans_a");
  m_trans_b = gpio_uvc_sequence_item::type_id::create ("m_trans_b");
  m_trans_c = gpio_uvc_sequence_item::type_id::create ("m_trans_c");
  m_cov = new();
endfunction : new


function void top_coverage::build_phase(uvm_phase phase);
  port_a_imp_export = new("port_a_imp_export", this);
  port_b_imp_export = new("port_b_imp_export", this);
  port_c_imp_export = new("port_c_imp_export", this);
endfunction : build_phase


function void top_coverage::write_port_a(input gpio_uvc_sequence_item t);
  m_trans_a = t;
  m_cov.sample();
endfunction : write_port_a


function void top_coverage::write_port_b(input gpio_uvc_sequence_item t);
  m_trans_b = t;
  m_cov.sample();
endfunction : write_port_b


function void top_coverage::write_port_c(input gpio_uvc_sequence_item t);
  m_trans_c = t;
  m_cov.sample();
endfunction : write_port_c

function void top_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("FINAL Coverage Score = %3.1f%%", m_cov.get_coverage()), UVM_DEBUG)
endfunction : report_phase

`endif // TOP_COVERAGE_SV
