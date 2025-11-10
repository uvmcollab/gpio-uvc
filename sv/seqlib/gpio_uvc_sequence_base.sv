`ifndef GPIO_UVC_SEQUENCE_BASE_SV
`define GPIO_UVC_SEQUENCE_BASE_SV

class gpio_uvc_sequence_base extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_base)
  rand gpio_uvc_sequence_item m_trans;
  extern function new(string name = "");

  extern virtual task body();

endclass : gpio_uvc_sequence_base


function gpio_uvc_sequence_base::new(string name = "");
  super.new(name);
  m_trans = gpio_uvc_sequence_item::type_id::create("m_trans");
endfunction : new


task gpio_uvc_sequence_base::body();
//Tengo un ítem listo, espera a que el driver te lo pida.
  start_item(m_trans);
  finish_item(m_trans);
endtask : body

`endif  // GPIO_UVC_SEQUENCE_BASE_SV
