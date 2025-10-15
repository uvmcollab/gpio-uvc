`ifndef GPIO_UVC_DRIVER_SV
`define GPIO_UVC_DRIVER_SV

class gpio_uvc_driver extends uvm_driver #(gpio_uvc_sequence_item);

  `uvm_component_utils(gpio_uvc_driver)

  virtual gpio_uvc_if vif;
  gpio_uvc_config     m_config;

  extern function new(string name, uvm_component parent);

  extern task run_phase(uvm_phase phase);
  extern task do_drive();
  extern task drive_sync();
  extern task drive_async();

endclass : gpio_uvc_driver


function gpio_uvc_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task gpio_uvc_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    do_drive();
    seq_item_port.item_done();
  end
endtask : run_phase


task gpio_uvc_driver::drive_sync();
  @(vif.cb_drv);
  vif.cb_drv.gpio_pin <= req.m_gpio_pin;
    `uvm_info(get_type_name(), {"\n--- DRIVER (GPIO_UVC) ---", req.convert2string()}, UVM_DEBUG)
endtask : drive_sync


task gpio_uvc_driver::drive_async();
  vif.gpio_pin = req.m_gpio_pin;
    `uvm_info(get_type_name(), {"\n--- DRIVER (GPIO_UVC) ---", req.convert2string()}, UVM_DEBUG)

  if (req.m_delay_enable == GPIO_UVC_ITEM_DELAY_ON) begin
    #(req.m_delay_duration_ps * 1ps);
  end else begin
    @(vif.cb_drv);
  end
endtask : drive_async


task gpio_uvc_driver::do_drive();

  if (req.m_trans_type == GPIO_UVC_ITEM_ASYNC) begin
    drive_async();
  end else begin
    drive_sync();
  end
  
endtask : do_drive

`endif  // GPIO_UVC_DRIVER_SV
