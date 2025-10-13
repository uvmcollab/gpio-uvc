`ifndef GPIO_UVC_SEQUENCE_ITEM_SV
`define GPIO_UVC_SEQUENCE_ITEM_SV

class gpio_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item)

  // Transaction variables
  rand byte            m_data;

  extern function new(string name = "");

  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function string convert2string();

endclass : gpio_uvc_sequence_item


function gpio_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction : new


function void gpio_uvc_sequence_item::do_copy(uvm_object rhs);
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  m_data               = rhs_.m_data;
endfunction : do_copy


function bit gpio_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= (m_data               == rhs_.m_data);
  return result;
endfunction : do_compare


function void gpio_uvc_sequence_item::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0) `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else printer.m_string = convert2string();
endfunction : do_print


function string gpio_uvc_sequence_item::convert2string();
  string s;
  s = super.convert2string();
  $sformat(s, {s, "\n", "TRANSACTION INFORMATION (GPIO_UVC):"});
  $sformat(s, {s, "\n", "m_data = %d"}, m_data);
  return s;
endfunction : convert2string

`endif // GPIO_UVC_SEQUENCE_ITEM_SV