`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  top_env_config    m_config;

  gpio_uvc_config   m_port_rst_config;
  gpio_uvc_agent    m_port_rst_agent;
  
  gpio_uvc_config   m_port_a_config;
  gpio_uvc_agent    m_port_a_agent;

  gpio_uvc_config   m_port_b_config;
  gpio_uvc_agent    m_port_b_agent;

  gpio_uvc_config   m_port_c_config;
  gpio_uvc_agent    m_port_c_agent;

  top_vsqr          vsqr;

  top_scoreboard    m_scoreboard;

  top_coverage      m_coverage;

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

  // ========================== PORT RESET AGENT ========================== //
  m_port_rst_config = gpio_uvc_config::type_id::create("m_port_rst_config");
  m_port_rst_config.is_active = UVM_ACTIVE;
  m_port_rst_config.gpio_width = 'd1;
  m_port_rst_config.start_value = 'd0;

  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_port_rst_agent", "vif", m_port_rst_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_port_rst_config from config db")
  end

  uvm_config_db #(gpio_uvc_config)::set(this, "m_port_rst_agent", "config", m_port_rst_config);
  m_port_rst_agent = gpio_uvc_agent::type_id::create("m_port_rst_agent", this);

    // ========================== PORT A AGENT ========================== //
  m_port_a_config = gpio_uvc_config::type_id::create("m_port_a_config");
  m_port_a_config.is_active = UVM_ACTIVE;
  m_port_a_config.gpio_width = 'd8;
  m_port_a_config.start_value = 'd0;

  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_port_a_agent", "vif", m_port_a_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_port_a_config from config db")
  end

  uvm_config_db #(gpio_uvc_config)::set(this, "m_port_a_agent", "config", m_port_a_config);
  m_port_a_agent = gpio_uvc_agent::type_id::create("m_port_a_agent", this);


    // ========================== PORT B AGENT ========================== //
  m_port_b_config = gpio_uvc_config::type_id::create("m_port_b_config");
  m_port_b_config.is_active = UVM_ACTIVE;
  m_port_b_config.gpio_width = 'd8;
  m_port_b_config.start_value = 'd0;

  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_port_b_agent", "vif", m_port_b_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_port_b_config from config db")
  end

  uvm_config_db #(gpio_uvc_config)::set(this, "m_port_b_agent", "config", m_port_b_config);
  m_port_b_agent = gpio_uvc_agent::type_id::create("m_port_b_agent", this);

    // ========================== PORT C AGENT ========================== //
  m_port_c_config = gpio_uvc_config::type_id::create("m_port_b_config");
  m_port_c_config.is_active = UVM_PASSIVE;
  m_port_c_config.gpio_width = 'd8;
  m_port_c_config.start_value = 'd0;

  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_port_c_agent", "vif", m_port_c_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_port_c_config from config db")
  end

  uvm_config_db #(gpio_uvc_config)::set(this, "m_port_c_agent", "config", m_port_c_config);
  m_port_c_agent = gpio_uvc_agent::type_id::create("m_port_c_agent", this);

  // ================================= COVERAGE =============================== //
  m_coverage  = top_coverage::type_id::create("m_coverage", this);

  // =============================== SCOREBOARD =============================== //
  m_scoreboard = top_scoreboard::type_id::create("m_scoreboard", this);

  // =========================== VIRTUAL SEQUENCER ============================ //
  vsqr = top_vsqr::type_id::create("vsqr", this);

endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
  // ===================== VIRTUAL SEQUENCER CONNECTIONS ====================== //
  vsqr.m_port_rst_sequencer  = m_port_rst_agent.m_sequencer;
  vsqr.m_port_a_sequencer = m_port_a_agent.m_sequencer;
  vsqr.m_port_b_sequencer = m_port_b_agent.m_sequencer;
  vsqr.m_port_c_sequencer = m_port_c_agent.m_sequencer;


  // ========================= SCOREBOARD CONNECTIONS ========================= //
  m_port_a_agent.analysis_port.connect(m_scoreboard.port_a_imp_export);
  m_port_b_agent.analysis_port.connect(m_scoreboard.port_b_imp_export);
  m_port_c_agent.analysis_port.connect(m_scoreboard.port_c_imp_export);

  // =========================== COVERAGE CONNECTIONS ========================= //
  m_port_a_agent.analysis_port.connect(m_coverage.port_a_imp_export);
  m_port_b_agent.analysis_port.connect(m_coverage.port_b_imp_export);
  m_port_c_agent.analysis_port.connect(m_coverage.port_c_imp_export);

endfunction : connect_phase

`endif // TOP_ENV_SV
