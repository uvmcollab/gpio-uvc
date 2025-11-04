`ifndef GPIO_UVC_PKG_SV
`define GPIO_UVC_PKG_SV

package gpio_uvc_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "gpio_uvc_types.sv"
  `include "gpio_uvc_sequence_item.sv"
  `include "gpio_uvc_config.sv"
  `include "gpio_uvc_sequencer.sv"
  `include "gpio_uvc_driver.sv"
  `include "gpio_uvc_monitor.sv"
  `include "gpio_uvc_agent.sv"

  `include "gpio_uvc_sequence_base.sv"
  `include "gpio_uvc_sequence_pulse.sv"
  `include "gpio_uvc_sequence_from_file.sv"
endpackage : gpio_uvc_pkg

`endif // GPIO_UVC_PKG_SV