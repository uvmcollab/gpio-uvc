`ifndef TOP_TEST_VSEQ_SV
`define TOP_TEST_VSEQ_SV

class top_test_vseq extends uvm_sequence;

  `uvm_object_utils(top_test_vseq)
  `uvm_declare_p_sequencer(top_vsqr)

  //virtual gpio_uvc_if vif;
  rand int unsigned iter;

  extern function new(string name = "");

  extern task gpio_uvc_seq();
  extern task body();
  constraint iter_c {iter inside {[1:100]};}
endclass : top_test_vseq


function top_test_vseq::new(string name = "");
  super.new(name);
 // vif =  p_sequencer.m_gpio_sequencer.m_config.vif; 

endfunction : new


task top_test_vseq::gpio_uvc_seq();
  // Write your sequence here
   gpio_uvc_sequence_base seq;
   seq = gpio_uvc_sequence_base::type_id::create("seq");
   if (!seq.randomize() with {
      m_trans.m_gpio_pin inside {[10:20]};
      m_trans.m_trans_type == GPIO_UVC_ITEM_SYNC;
      m_trans.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;
      }) begin
     `uvm_fatal(get_name(), "Failed to randomize sequence")
   end
   seq.start(p_sequencer.m_gpio_sequencer);
endtask : gpio_uvc_seq


task top_test_vseq::body();
  // Initial delay
  #(200ns);

  repeat(iter) begin
    gpio_uvc_seq();
  end

  // Drain time 
  #(1000ns);
endtask : body

`endif // TOP_TEST_VSEQ_SV