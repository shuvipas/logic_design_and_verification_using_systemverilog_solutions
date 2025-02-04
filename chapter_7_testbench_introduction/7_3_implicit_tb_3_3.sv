
module top73;
logic clk,rstn,i,j,x,y;

fsm_prob_b dut(.*);
tb3_3 tb(.*);
initial begin
    
end
endmodule

module tb3_3(
    input logic clk, 
    output logic i,j);

endmodule