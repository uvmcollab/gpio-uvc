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
  gpio_uvc_if port_rst_vif  (clk_i);



  // DUT Instantiation
  adder dut (
    .clk_i (clk_i),
    .rst_i (port_rst_vif.gpio_pin[0]),
    .a_i   (),
    .b_i   (),
    .sum_o  ()
  );

  initial begin
    $timeformat(-12, 0, "ps", 10);
    uvm_config_db #(virtual gpio_uvc_if)::set(null, "uvm_test_top.m_env.m_port_rst_agent", "vif", port_rst_vif );
    run_test();
  end

endmodule : tb
