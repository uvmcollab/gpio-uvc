`ifndef GPIO_UVC_CONFIG_SV
`define GPIO_UVC_CONFIG_SV

class gpio_uvc_config extends uvm_object;
  
  `uvm_object_utils(gpio_uvc_config)

  virtual gpio_uvc_if    vif;
  uvm_active_passive_enum  is_active = UVM_ACTIVE;

  extern function new(string name = "");

endclass : gpio_uvc_config

function gpio_uvc_config::new(string name = "");
  super.new(name);
endfunction : new

`endif // GPIO_UVC_CONFIG_SV