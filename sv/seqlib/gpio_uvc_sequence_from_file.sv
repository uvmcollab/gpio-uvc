`ifndef GPIO_UVC_SEQUENCE_FROM_FILE_SV
`define GPIO_UVC_SEQUENCE_FROM_FILE_SV

class gpio_uvc_sequence_from_file extends uvm_sequence #(gpio_uvc_sequence_item);

  `uvm_object_utils(gpio_uvc_sequence_from_file)

  gpio_uvc_sequence_item m_queue_trans[$];
  string                 m_file_name;

  extern function new(string name = "");

  extern function void read_from_file();
  extern virtual task body();

endclass : gpio_uvc_sequence_from_file


function gpio_uvc_sequence_from_file::new(string name = "");
  super.new(name);
endfunction : new


function void gpio_uvc_sequence_from_file::read_from_file();
  int    file;
  int    result;
  gpio_uvc_sequence_item trans;

  int    gpio_val;
  string trans_type_str;
  string delay_enable_str;
  string align_type_str;
  int    delay_duration;
  int    delay_cycles;

  file = $fopen(m_file_name, "r");
  if (!file) begin
    `uvm_fatal("FILE_ERROR", $sformatf("Failed to open file: %s", m_file_name))
  end

  while (!$feof(file)) begin
    trans  = gpio_uvc_sequence_item::type_id::create("trans");
    result = $fscanf(file, "%d %s %s %s %d %d", gpio_val, trans_type_str, delay_enable_str, align_type_str, delay_duration, delay_cycles);

    if (result == 6) begin
      trans.m_gpio_pin = gpio_val;
      trans.m_delay_duration_ps = delay_duration;
      trans.m_delay_cycles = delay_cycles;

      // Parse transaction type
      if (trans_type_str == "GPIO_UVC_ITEM_ASYNC") begin
        trans.m_trans_type = GPIO_UVC_ITEM_ASYNC;
      end else if (trans_type_str == "GPIO_UVC_ITEM_SYNC") begin
        trans.m_trans_type = GPIO_UVC_ITEM_SYNC;
      end else begin
        `uvm_fatal("PARSE ERROR", $sformatf("Failed to parse trans_type"))
      end

      // Parse delay type
      if (delay_enable_str == "GPIO_UVC_ITEM_DELAY_ON") begin
        trans.m_delay_enable = GPIO_UVC_ITEM_DELAY_ON;
      end else if (delay_enable_str == "GPIO_UVC_ITEM_DELAY_OFF") begin
        trans.m_delay_enable = GPIO_UVC_ITEM_DELAY_OFF;
      end else begin
        `uvm_fatal("PARSE ERROR", $sformatf("Failed to parse delay_enable"))
      end

      // Parse align type
      if (align_type_str == "GPIO_UVC_ITEM_ALIGN_TYPE_RISING") begin
        trans.m_align_type = GPIO_UVC_ITEM_ALIGN_TYPE_RISING;
      end else if (align_type_str == "GPIO_UVC_ITEM_ALIGN_TYPE_FALLING") begin
        trans.m_align_type = GPIO_UVC_ITEM_ALIGN_TYPE_FALLING;
      end else begin
        `uvm_fatal("PARSE ERROR", $sformatf("Failed to parse align_type"))
      end

      // Store the item in the queue
      m_queue_trans.push_back(trans);

    end else if (result == -1) begin
      `uvm_info("PARSE WARNING", $sformatf("Blanck line detected, skipping this line"), UVM_MEDIUM)
      continue;
    end else begin
      `uvm_fatal("PARSE ERROR", $sformatf("Failed to parse line correctly"))
    end

  end

  // Close file
  $fclose(file);

endfunction : read_from_file

task gpio_uvc_sequence_from_file::body();
  read_from_file();
  foreach (m_queue_trans[i]) begin
    start_item(m_queue_trans[i]);
    finish_item(m_queue_trans[i]);
  end
endtask : body

`endif // GPIO_UVC_SEQUENCE_FROM_FILE_SV
