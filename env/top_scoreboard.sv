`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV



class top_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(top_scoreboard)

  `uvm_analysis_imp_decl(_gpio_data)
uvm_analysis_imp_gpio_data #(gpio_uvc_sequence_item,top_scoreboard) gpio_data_imp_export;

  int m_num_passed;
  int m_num_failed;

    gpio_uvc_sequence_item m_a_queue[$];


  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

// Esta función se ejecutara siemore que el monitor mande al analysys port
// un valor
  extern function void write_gpio_data(input gpio_uvc_sequence_item t);

//tarea para realizar la suma
  extern function int ref_model(input gpio_uvc_sequence_item trans_A, gpio_uvc_sequence_item trans_B);

endclass : top_scoreboard


function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  m_num_passed = 0;
  m_num_failed = 0;
endfunction : new


function void top_scoreboard::build_phase(uvm_phase phase);

  gpio_data_imp_export = new("gpio_data_imp_export", this);
endfunction : build_phase


task top_scoreboard::run_phase(uvm_phase phase);

int valor_esperado;
int valor_modelo_referencia;
string check;
string s;
int last_index;
forever begin
wait( m_a_queue.size() >= 2);

 last_index = m_a_queue.size() - 1;

foreach(m_a_queue[i]) begin
 valor_esperado = ref_model(m_a_queue[last_index-1], m_a_queue[last_index]);


if (valor_esperado == m_a_queue[0].m_gpio_pin+m_a_queue[1].m_gpio_pin)begin
      check = "PASSED";
      m_num_passed++;

                   `uvm_info(get_type_name(), $sformatf("PASS:  (Primer valor=%0d,Segundo  valor=%0d,
                   Primer valor index =%0d,Segundo valor index=%0d, valor esperado=%0d, valor de referencia = %0d)",
                                                    m_a_queue[0].m_gpio_pin, m_a_queue[1].m_gpio_pin,
                                                    m_a_queue[last_index-1].m_gpio_pin, m_a_queue[last_index].m_gpio_pin,
                                                   valor_esperado,m_a_queue[i].m_gpio_pin[0]+m_a_queue[i].m_gpio_pin[1] ), UVM_LOW)

    end else begin
      check = "FAILED";
      m_num_failed++;

                         `uvm_info(get_type_name(), $sformatf("FALLO: (Primer valor=%0d,Segundo  valor=%0d,
                   Primer valor index =%0d,Segundo valor index=%0d, valor esperado=%0d,valor de referencia = %0d)",
                                                    m_a_queue[0].m_gpio_pin, m_a_queue[1].m_gpio_pin,
                                                    m_a_queue[last_index-1].m_gpio_pin, m_a_queue[last_index].m_gpio_pin,
                                                   valor_esperado,m_a_queue[0].m_gpio_pin+m_a_queue[1].m_gpio_pin), UVM_LOW)


    end

`uvm_info(get_type_name(),
  $sformatf("\na = %3d, valor referencia = %3d",
  m_a_queue[i].m_gpio_pin, valor_esperado),
  UVM_DEBUG)


end
 foreach (m_a_queue[i]) begin
   s = {s, $sformatf("\nTRANS[%3d]: \n ------ SCOREBOARD (ADDER UVC) ------  ", i), m_a_queue[i].convert2string(), "\n"};
 end
       `uvm_info(get_type_name(), s, UVM_DEBUG)
        s="";

    
    m_a_queue.delete();


end


endtask : run_phase

function int top_scoreboard::ref_model(input gpio_uvc_sequence_item trans_A, gpio_uvc_sequence_item trans_B);
  return (trans_A.m_gpio_pin[7:0] + trans_B.m_gpio_pin[7:0]); // accede al m_gpio_pin definido en el item
endfunction : ref_model


// viene el write y viene la transaction del monitor
function void top_scoreboard::write_gpio_data(input gpio_uvc_sequence_item t);

//Creo una transaction igual
  gpio_uvc_sequence_item received_trans;
  received_trans = gpio_uvc_sequence_item::type_id::create("received_trans");

//copio los valores de t en received_trans declarados en el item
  received_trans.do_copy(t); // cuando el monitor escribe, se ejecuta esta instrucción
  m_a_queue.push_back(received_trans);
endfunction : write_gpio_data


function void top_scoreboard::report_phase(uvm_phase phase);
// imprimimos las queue
// string s;
// foreach (m_a_queue[i]) begin
//   s = {s, $sformatf("\nTRANS[%3d]: \n ------ SCOREBOARD (ADDER UVC) ------  ", i), m_a_queue[i].convert2string(), "\n"};
// end
//       `uvm_info(get_type_name(), s, UVM_DEBUG)
//        s="";
  `uvm_info(get_type_name(), $sformatf("PASSED = %3d, FAILED = %3d", m_num_passed, m_num_failed), UVM_MEDIUM)

endfunction : report_phase

`endif // TOP_SCOREBOARD_SV