`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;

  `uvm_component_utils(top_env)

  top_env_config    m_config;

  gpio_uvc_config m_gpio_uvc_data_config;
  gpio_uvc_agent  m_gpio_uvc_data_agent;
  
  gpio_uvc_config m_gpio_uvc_rst_config;
  gpio_uvc_agent  m_gpio_uvc_rst_agent;

  top_vsqr          vsqr;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : top_env


function top_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_env::build_phase(uvm_phase phase);
    // utilizar el metodo get para entrar a la base de datos de 
    // configuracion de uvm para obtener un objeto de tipo top_env_config
    // en el contexto de this ("uvm_test_top.m_env) con el nombre ""  y obtengo el 
    //objeto config y lo guardo en el miembro m_config

  if (!uvm_config_db#(top_env_config)::get(this, "", "config", m_config)) begin

    `uvm_fatal(get_name(), "Could not retrieve top_env_config from config db")
  end

  // ===============================DATA AGENT =========================================== //
  m_gpio_uvc_data_config = gpio_uvc_config::type_id::create("m_gpio_uvc_data_config");
  m_gpio_uvc_data_config.is_active = UVM_ACTIVE;
  m_gpio_uvc_data_config.gpio_width = 'd32;

  //“Dentro de todos los componentes que estén bajo m_gpio_agent,
//asigna el vif a apuntar al gpio_uvc_vif físico.”
  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_gpio_uvc_data_agent", "vif", m_gpio_uvc_data_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_gpio_uvc_data_config from config db")
  end
  
  uvm_config_db #(gpio_uvc_config)::set(this, "m_gpio_uvc_data_agent", "config", m_gpio_uvc_data_config);
  m_gpio_uvc_data_agent = gpio_uvc_agent::type_id::create("m_gpio_uvc_data_agent", this);
// Creo el handle tipo top_vsqr y lo instancio, el this es porque 
//el environment es el padre


  // =========================== RESET AGENTE==================================== //
  m_gpio_uvc_rst_config = gpio_uvc_config::type_id::create("m_gpio_uvc_rst_config");
  m_gpio_uvc_rst_config.is_active = UVM_ACTIVE;
  m_gpio_uvc_rst_config.gpio_width = 'b1;

  //“Dentro de todos los componentes que estén bajo m_gpio_agent,
//asigna el vif a apuntar al gpio_uvc_vif físico.”
  if (!uvm_config_db#(virtual gpio_uvc_if)::get(this, "m_gpio_uvc_rst_agent", "vif", m_gpio_uvc_rst_config.vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve m_gpio_uvc_rst_config from config db")
  end
  
  uvm_config_db #(gpio_uvc_config)::set(this, "m_gpio_uvc_rst_agent", "config", m_gpio_uvc_rst_config);
  m_gpio_uvc_rst_agent = gpio_uvc_agent::type_id::create("m_gpio_uvc_rst_agent", this);
// Creo el handle tipo top_vsqr y lo instancio, el this es porque 
//el environment es el padre



  vsqr = top_vsqr::type_id::create("vsqr", this);

endfunction : build_phase


function void top_env::connect_phase(uvm_phase phase);
//Conecatamo el virtual sequencer vsqr con el 
//sequencer del agente m_gpio_uvc_agent

  vsqr.m_gpio_data_sequencer = m_gpio_uvc_data_agent.m_sequencer;
  vsqr.m_gpio_rst_sequencer = m_gpio_uvc_rst_agent.m_sequencer;

//   top_test (vseq)
//        │
//        ▼
// vsqr (virtual sequencer)
//        │ apunta a
// m_gpio_uvc_agent.m_sequencer (sequencer real)
//        │ distribuye a
// ┌─────────────┬─────────────┐
// │             │             │
// driver        monitor      coverage/scoreboard
// │             │
// DUT          observa señales

endfunction : connect_phase

`endif // TOP_ENV_SV