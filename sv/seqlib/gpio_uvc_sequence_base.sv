`ifndef GPIO_UVC_SEQUENCE_BASE_SV
`define GPIO_UVC_SEQUENCE_BASE_SV

class gpio_uvc_sequence_base extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_base)

  extern function new(string name = "");

  extern virtual task body();

endclass : gpio_uvc_sequence_base


function gpio_uvc_sequence_base::new(string name = "");
  super.new(name);
endfunction : new


task gpio_uvc_sequence_base::body();
    req = gpio_uvc_sequence_item::type_id::create("req");
    start_item(req);
    if ( !req.randomize() ) begin
      `uvm_error(get_type_name(), "Failed to randomize transaction")
    end
    finish_item(req);
endtask : body

`endif // GPIO_UVC_SEQUENCE_BASE_SV