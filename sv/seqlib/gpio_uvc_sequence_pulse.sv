`ifndef GPIO_UVC_SEQUENCE_PULSE_SV
`define GPIO_UVC_SEQUENCE_PULSE_SV

class gpio_uvc_sequence_pulse extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_pulse)

  rand gpio_uvc_sequence_item m_pin_assert;
  rand gpio_uvc_sequence_item m_pin_deassert;

  extern function new(string name = "");

  extern virtual task body();

endclass : gpio_uvc_sequence_pulse


function gpio_uvc_sequence_pulse::new(string name = "");
  super.new(name);
  m_pin_assert   = gpio_uvc_sequence_item::type_id::create("m_pin_assert");
  m_pin_deassert = gpio_uvc_sequence_item::type_id::create("m_pin_deassert");
endfunction : new


task gpio_uvc_sequence_pulse::body();
  start_item(m_pin_assert);
  finish_item(m_pin_assert);

  start_item(m_pin_deassert);
  finish_item(m_pin_deassert);

  start_item(m_pin_assert);
  finish_item(m_pin_assert);
  
  start_item(m_pin_deassert);
  finish_item(m_pin_deassert);
  
endtask : body

`endif // GPIO_UVC_SEQUENCE_PULSE_SV
