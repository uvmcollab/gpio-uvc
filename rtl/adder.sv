
module adder#(
    parameter int width = 8
)
(
    input logic clk_i,
    input logic rst_i,
    input logic [width-1:0] a_i,
    input logic [width-1:0] b_i,
    output logic [width-1:0] sum_o
);

//Reset sincrono
always @(posedge clk_i) begin
    if(rst_i) 
        sum_o <= '0;
    else 
        sum_o <= a_i + b_i;
    end

endmodule : adder