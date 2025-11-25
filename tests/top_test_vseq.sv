`ifndef TOP_TEST_VSEQ_SV
`define TOP_TEST_VSEQ_SV

class top_test_vseq extends uvm_sequence;

  `uvm_object_utils(top_test_vseq)
  `uvm_declare_p_sequencer(top_vsqr)

  rand int unsigned iter;

  extern function new(string name = "");

//  extern task gpio_uvc_seq();
//  extern task gpio_uvc_rst();
  extern task port_rst_seq();
  extern task port_a_seq(string filename);
  extern task port_b_seq(string filename);
  extern task body();
  constraint iter_c {iter inside {[1 : 2]};}
endclass : top_test_vseq


function top_test_vseq::new(string name = "");
  super.new(name);
  // vif =  p_sequencer.m_gpio_sequencer.m_config.vif; 

endfunction : new


// task top_test_vseq::gpio_uvc_seq();
//   // Write your sequence here
//   gpio_uvc_sequence_base seq;
//   seq = gpio_uvc_sequence_base::type_id::create("seq");
//   if (!seq.randomize() with {
//
//         m_trans.m_gpio_pin inside {[10 : 20]};
//         m_trans.m_trans_type == GPIO_UVC_ITEM_SYNC;
//         m_trans.m_delay_enable == GPIO_UVC_ITEM_DELAY_ON;
//       //  m_trans.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;
//       }) begin
//     `uvm_fatal(get_name(), "Failed to randomize sequence")
//   end
//   // Mando las senceucnias que acabo de randomizar haceia el sequencer
//   // Ejecuta esta secuencia (seq) que configure(seqeunce_base _pulse)
//   // sobre este secuenciador (m_gpio_data_sequencer) que pertenece a p_sequencer
//   //UVM entra automaticamente al body
//   seq.start(p_sequencer.m_gpio_data_sequencer);
//
//  //p_sequencer es mi virtual sequence(top_vsqr), es un grupo de secuenciadores que tiene varios agentes
//// “Del grupo p_sequencer, usa el secuenciador m_gpio_data_sequencer
////y ejecuta allí mi secuencia seq. Luego deja que UVM llame al body()
////para generar y mandar la transacción al DUT.”
// endtask : gpio_uvc_seq

// task top_test_vseq::gpio_uvc_rst();
//   // Write your sequence here
//   gpio_uvc_sequence_base seq;
//   seq = gpio_uvc_sequence_base::type_id::create("seq");
//   if (!seq.randomize() with {
//         m_trans.m_gpio_pin == 'b1;
//         m_trans.m_trans_type == GPIO_UVC_ITEM_SYNC;
//         m_trans.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;
//        // m_trans.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;
//       }) begin
//     `uvm_fatal(get_name(), "Failed to randomize sequence")
//   end
//   // Mando las sencuencias que acabo de randomizar hacia el sequencer
//   // 
//   seq.start(p_sequencer.m_gpio_rst_sequencer);
//   seq.m_trans.m_gpio_pin = 'b0;
//   seq.start(p_sequencer.m_gpio_rst_sequencer);

//   //  seq.m_trans.m_gpio_pin = 'b1;
//   //  seq.m_trans.m_trans_type = GPIO_UVC_ITEM_ASYNC;
//   //  seq.m_trans.m_delay_enable = GPIO_UVC_ITEM_DELAY_ON;
//   //  seq.m_trans.m_delay_duration_ps = 250_000;
//   //  seq.start(p_sequencer.m_gpio_rst_sequencer);

// endtask : gpio_uvc_rst

task top_test_vseq::port_rst_seq();
gpio_uvc_sequence_pulse seq;
seq = gpio_uvc_sequence_pulse::type_id::create("seq");

if (! seq.randomize() with { 
    m_pin_assert.m_gpio_pin == 1'b1;
    m_pin_assert.m_trans_type == GPIO_UVC_ITEM_SYNC;
    m_pin_assert.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;
    m_pin_assert.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;    
    m_pin_deassert.m_gpio_pin == 1'b0;
    m_pin_deassert.m_trans_type == GPIO_UVC_ITEM_SYNC;
    m_pin_deassert.m_delay_enable == GPIO_UVC_ITEM_DELAY_OFF;  
    m_pin_deassert.m_align_type == GPIO_UVC_ITEM_ALIGN_TYPE_RISING;    
 
         }) begin
     `uvm_fatal(get_name(), "Failed to randomize sequence")
   end
  seq.start(p_sequencer.m_port_rst_sequencer);
endtask: port_rst_seq

  task top_test_vseq::port_a_seq(string filename);
  gpio_uvc_sequence_from_file seq;
  seq = gpio_uvc_sequence_from_file::type_id::create("seq");
  seq.m_file_name = {`GIT_DIR, filename};
  seq.start(p_sequencer.m_port_a_sequencer);
  endtask: port_a_seq

  task top_test_vseq::port_b_seq(string filename);
  gpio_uvc_sequence_from_file seq;
  seq = gpio_uvc_sequence_from_file::type_id::create("seq");
  seq.m_file_name = {`GIT_DIR, filename};
  seq.start(p_sequencer.m_port_b_sequencer);
  endtask: port_b_seq

task top_test_vseq::body();
  //gpio_uvc_rst();
  port_rst_seq();
  // Initial delay
  #(200ns);

  //repeat (iter) begin
    //gpio_uvc_seq();
    fork 
    port_a_seq("/sv/seqlib/sample.seq");
    port_b_seq("/sv/seqlib/sample.seq");
    join
  //end

  // Drain time 
  #(1000ns);

endtask : body

`endif  // TOP_TEST_VSEQ_SV
