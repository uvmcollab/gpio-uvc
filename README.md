# GPIO_UVC

This is a UVC designed to manage asynchronous and synchronous GPIOs. In this project, we use a 32-bit width. We also worked with parameters that can be modified, making it easy to change any of their values.

## Integration guide

### Add the UVC in Your project

Clone the repository into your `uvcs/` directory.

```plain
git clone https://github.com/uvmcollab/gpio_uvc.git
```

Alternatively, you can add the UVC as a submodule by running the
`git submodule add` command from the root directory of your main Git repository:

```plain
git submodule add git@github.com:uvmcollab/gpio_uvc.git verification/uvm/uvcs/gpio_uvc
```

A `.gitmodules` file will be created. Now commit the changes:

```plain
git add .gitmodules verification/uvm/uvcs/gpio_uvc
git commit -m "feat: add gpio_uvc as a submodule"
```

### Directory Structure Convention

The following directory structure is required to integrate the UVC:

```plain
├── docs /                (Documentation)                      [Optional]
├── dpi/                  (Direct Programming Interface)       [Optional]
├── env/
├── env/
│   ├── top_env_config.sv (Environment configuration)          [Optional]
│   ├── top_env_pkg.sv    (Environment package)
│   ├── top_env.sv        (Environment)   
│   ├── top_scoreboard.sv (Scoreboard)                         [Optional]
│   └── top_vsqr.sv       (Virtual sequencer)
├── scripts/
│   ├── makefiles/
│   ├── filter/
│   ├── setup/
│   └── verdi
├── sve.f                 (Simulation Verification Environment)
├── gpio_uvc.f
├── tb/
│   └── tb.sv             (Testbench top)
├── tests/
│   ├── top_test_pkg.sv   (Top test package)
│   ├── top_test.sv       (Top test)
│   └── top_test_vseq.sv  (Virtual sequence)
└── uvcs/
    └── gpio_uvc/
        └── sv/
            └── seqlib/
```

### Step-by-Step
**Import `gpio_uvc_pkg`**.
In both `top_env_pkg.sv` and `top_test_pkg.sv`, import `gpio_uvc_pkg` after the `uvm_pkg` to make
the UVC component available.

```verilog
package top_test_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // UVCs
  import gpio_uvc_pkg::*;
  ...

endpackage : top_test_pkg
```

### Example sequences

**1. To drive an active-low synchronous reset with synchronous deassertions:**

```verilog

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
```
**2. To drive ports A and B with random values using import text File:**

```verilog
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
```

The format of the text file is:

```plain
8   GPIO_UVC_ITEM_ASYNC GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING   100_000  10_000
4   GPIO_UVC_ITEM_ASYNC GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING   100_000  10_000    
9   GPIO_UVC_ITEM_ASYNC GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING   100_000  10_000 
7   GPIO_UVC_ITEM_ASYNC GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING   100_000  10_000 
10  GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING  10  10  
9   GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_ON GPIO_UVC_ITEM_ALIGN_TYPE_RISING  10  10  
8   GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_OFF GPIO_UVC_ITEM_ALIGN_TYPE_FALLING 10_000  1_000  
7   GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_OFF GPIO_UVC_ITEM_ALIGN_TYPE_FALLING 10_000  1_000  
250 GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_OFF GPIO_UVC_ITEM_ALIGN_TYPE_FALLING 10_000  1_000  
255 GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_OFF GPIO_UVC_ITEM_ALIGN_TYPE_FALLING 10_000  1_000  
0   GPIO_UVC_ITEM_SYNC  GPIO_UVC_ITEM_DELAY_OFF GPIO_UVC_ITEM_ALIGN_TYPE_FALLING 10_000  1_000  
```

| Column | Attribute        | Description/Format                                    |
| ------ | ---------------- | ----------------------------------------------------- |
| 1      | `m_gpio_pin`     | Decimal format                                        |
| 2      | `m_trans_type`   | `GPIO_UVC_ITEM_SYNC` or `GPIO_UVC_ITEM_ASYNC`        |
| 3      | `m_delay_enable` | `GPIO_UVC_ITEM_DELAY_ON` or `GPIO_UVC_ITEM_DELAY_OFF`        |
| 4      | `align_type`     | `GPIO_UVC_ITEM_ALIGN_TYPE_RISING` or `GPIO_UVC_ITEM_ALIGN_TYPE_FALLING`        |
| 5      | `delay_duration` | Decimal format |
| 6      | `delay_cycles`   | Decimal format                                        |

> Note: The text file must not contain any blank lines at the end.

**In the `body()` Task, Select the sequence Execution Order:**
In this case, we call the reset task, wait for a delay, and use a fork-join to read the text file for ports A and B. After sending the values, we wait for a drain time.

```verilog
task top_test_vseq::body();
  port_rst_seq();
  // Initial delay
  #(200ns);
    fork 
    port_a_seq("/sv/seqlib/sample.seq");
    port_b_seq("/sv/seqlib/sample.seq");
    join
  //end

  // Drain time 
  #(1000ns);

endtask : body
```

## Testing

This repository includes a simple adder as a DUT for testing the UVC
functionality. Feel free to explore the files as they serve as a complete
example of how to use the UVC.


## Setup

From the root directory run the following:

### For bash

```bash
export GIT_ROOT="$(git rev-parse --show-toplevel)"
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p "$UVM_WORK" && cd "$UVM_WORK"
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.vcs Makefile
ln -sf $GIT_ROOT/scripts/setup/setup_synopsys_eda.tcsh
source setup_xilinx_eda.sh
make
```

### For tcsh

```bash
setenv GIT_ROOT `git rev-parse --show-toplevel`
setenv UVM_WORK $GIT_ROOT/work/uvm
mkdir -p $UVM_WORK && cd $UVM_WORK
ln -sf $GIT_ROOT/scripts/makefiles/Makefile.vcs Makefile
ln -sf $GIT_ROOT/scripts/setup/setup_synopsys_eda.tcsh
source setup_synopsys_eda.tcsh
make
```
