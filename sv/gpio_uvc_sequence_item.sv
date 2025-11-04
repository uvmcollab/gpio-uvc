`ifndef GPIO_UVC_SEQUENCE_ITEM_SV
`define GPIO_UVC_SEQUENCE_ITEM_SV

class gpio_uvc_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(gpio_uvc_sequence_item)

  // Transaction variables
  rand gpio_uvc_data_t            m_gpio_pin;  // Random data 
  rand gpio_uvc_item_type_e       m_trans_type;  // synchronous or asynchronous
  rand gpio_uvc_item_delay_e      m_delay_enable;  //transaction delay
  rand int unsigned               m_delay_duration_ps;  // delay duration asyn
  rand int unsigned               m_delay_cycles;  // number of delay cycles sync
  rand gpio_uvc_item_align_type_e m_align_type;  // define alignment type, sync 


  extern function new(string name = "");

  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
  extern function string convert2string();

  constraint c_delay_duration_ps {soft m_delay_duration_ps inside {[1_000 : 10_000]};}
  constraint c_delay_cycles {soft m_delay_cycles inside {[1 : 10]};}
  constraint c_align_type {soft m_align_type inside {[0:1]};}

endclass : gpio_uvc_sequence_item


function gpio_uvc_sequence_item::new(string name = "");
  super.new(name);
endfunction : new


function void gpio_uvc_sequence_item::do_copy(uvm_object rhs);
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);
  m_gpio_pin          = rhs_.m_gpio_pin;
  m_trans_type        = rhs_.m_trans_type;
  m_delay_duration_ps = rhs_.m_delay_duration_ps;
  m_delay_enable      = rhs_.m_delay_enable;
  m_delay_cycles      = rhs_.m_delay_cycles;
  m_align_type        = rhs_.m_align_type;

endfunction : do_copy


function bit gpio_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit result;
  gpio_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  result = super.do_compare(rhs, comparer);
  result &= (m_gpio_pin == rhs_.m_gpio_pin);
  result &= (m_trans_type == rhs_.m_trans_type);
  result &= (m_delay_duration_ps == rhs_.m_delay_duration_ps);
  result &= (m_delay_enable == rhs_.m_delay_enable);
  result &= (m_delay_cycles == rhs_.m_delay_cycles);
  result &= (m_align_type == rhs_.m_align_type);

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
  $sformat(s, {s, "\n", "m_gpio_pin = %d"}, m_gpio_pin);
  $sformat(s, {s, "\n", "m_trans_type = %d"}, m_trans_type);
  $sformat(s, {s, "\n", "m_delay_duration_ps = %d"}, m_delay_duration_ps);
  $sformat(s, {s, "\n", "m_delay_enable = %d"}, m_delay_enable);
  $sformat(s, {s, "\n", "m_delay_cycles = %d"}, m_delay_cycles);
  $sformat(s, {s, "\n", "m_align_type = %d"}, m_align_type);

  return s;
endfunction : convert2string

`endif  // GPIO_UVC_SEQUENCE_ITEM_SV
