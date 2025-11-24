module tb;
  timeunit 1ns; timeprecision 100ps;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import top_test_pkg::*;

  // Clock signal
  localparam time CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Interface
  gpio_uvc_if port_uvc_rst_vif (clk_i);
  gpio_uvc_if port_uvc_a_vif  (clk_i);
  gpio_uvc_if port_uvc_b_vif (clk_i);
  gpio_uvc_if port_uvc_c_vif (clk_i);

  // DUT Instantiation
  adder dut (
    .clk_i (clk_i),
    .rst_i (port_uvc_a_vif.gpio_pin[0]),
    .a_i   (port_uvc_a_vif.gpio_pin[8:1]),
    .b_i   (port_uvc_a_vif.gpio_pin[8:1]),
    .sum_o (port_uvc_c_vif.gpio_pin[8:1])
  );

  initial begin
    $timeformat(-12, 0, "ps", 10);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.m_env.m_port_uvc_rst_agent", "vif", port_uvc_rst_vif );
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.m_env.m_port_uvc_a_agent", "vif", port_uvc_a_vif );
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.m_env.m_port_uvc_b_agent", "vif", port_uvc_b_vif );  
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.m_env.m_port_uvc_c_agent", "vif", port_uvc_c_vif );  
    run_test();
  end

endmodule : tb
