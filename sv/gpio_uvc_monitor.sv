`ifndef GPIO_UVC_MONITOR_SV
`define GPIO_UVC_MONITOR_SV

class gpio_uvc_monitor extends uvm_monitor;

  `uvm_component_utils(gpio_uvc_monitor)

  uvm_analysis_port #(gpio_uvc_sequence_item) analysis_port;

  virtual gpio_uvc_if    vif;
  gpio_uvc_config        m_config;
  gpio_uvc_sequence_item m_trans;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : gpio_uvc_monitor


function gpio_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void gpio_uvc_monitor::build_phase(uvm_phase phase);
  analysis_port = new("analysis_port", this);
endfunction : build_phase


task gpio_uvc_monitor::run_phase(uvm_phase phase);
  m_trans = gpio_uvc_sequence_item::type_id::create("m_trans");
  do_mon();
endtask : run_phase


task gpio_uvc_monitor::do_mon();
  forever begin
    @(vif.gpio_pin);
    m_trans.m_gpio_pin = vif.gpio_pin;
    
    `uvm_info(get_type_name(), {"\n--- MONITOR (GPIO_UVC) ---", m_trans.convert2string()}, UVM_DEBUG)
    analysis_port.write(m_trans);
  end
endtask : do_mon

`endif // GPIO_UVC_MONITOR_SV