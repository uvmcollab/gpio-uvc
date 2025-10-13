`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  top_env_config    m_config;

  gpio_uvc_config m_gpio_uvc_config;
  gpio_uvc_agent  m_gpio_uvc_agent;

  top_vsqr          vsqr;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : top_env


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_env::build_phase(uvm_phase phase);
  if (!uvm_config_db#(top_env_config)::get(this, "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve top_env_config from config db")
  end

  // ========================================================================== //
  m_gpio_uvc_config = gpio_uvc_config::type_id::create("m_gpio_uvc_config");
  m_gpio_uvc_config.is_active = UVM_ACTIVE;
  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_gpio_uvc_agent", "vif", m_gpio_uvc_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_gpio_uvc_config from config db")
  end
  uvm_config_db #(gpio_uvc_config)::set(this, "m_gpio_uvc_agent", "config", m_gpio_uvc_config);
  m_gpio_uvc_agent = gpio_uvc_agent::type_id::create("m_gpio_uvc_agent", this);

  vsqr = top_vsqr::type_id::create("vsqr", this);
endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
  vsqr.m_gpio_sequencer = m_gpio_uvc_agent.m_sequencer;
endfunction : connect_phase

`endif // TOP_ENV_SV