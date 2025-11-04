`ifndef TOP_TEST_SV
`define TOP_TEST_SV

class top_test extends uvm_test;

  `uvm_component_utils(top_test)

  top_env        m_env;
  top_env_config m_env_config;
  top_test_vseq  vseq;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : top_test


function top_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void top_test::build_phase(uvm_phase phase);
  m_env_config = top_env_config::type_id::create("m_env_config");
  m_env_config.coverage_enable = 0;

  // Ocupo el metodo set para escribir en la base de datos de configuracion
  // de uvm un objeto de tipo top_env_config en el contexto 
  // de this (uvm_test_top) con el nombre "m_env" y la etiqueta "config"
  // y el objeto que voy a guardar ahi es es m_env_config
  uvm_config_db#(top_env_config)::set(this, "m_env", "config", m_env_config);

  m_env = top_env::type_id::create("m_env", this);
endfunction : build_phase


function void top_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_root::get().print_topology();
  uvm_factory::get().print();
endfunction : end_of_elaboration_phase


task top_test::run_phase(uvm_phase phase);
//Crear un handle a la instancia top_test_vseq: Todo lo que tenga
// top_test_vseq ahora es accesible a traves del handle vseq
  vseq = top_test_vseq::type_id::create("vseq");
  phase.raise_objection(this);
  if (!(vseq.randomize())) begin
    `uvm_fatal(get_type_name(), "Failed to randomize vseq")
  end
// Ejecutar el virtual sequence vseq sobre el virtual sequencer que esta
// dentro del environment m_env.vsqr
  vseq.start(m_env.vsqr);
  phase.drop_objection(this);
endtask : run_phase

`endif  // TOP_TEST_SV
