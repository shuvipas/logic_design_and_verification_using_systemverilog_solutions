`timescale 1ps / 1ps
module tb_param #(parameter outSize =4)
(output logic[outSize -1:0] out);

initial begin 
    out = 0;
    do begin
        #1 $display("out = %b //%d",out,out);
        out = out +1;
    end while(out !=0);
end
endmodule
module top71;
logic [4:0] out;
logic [3:0] def_size;
tb_param #(.outSize(5)) def5(.out(out)) ;
tb_param def(.out(def_size));
endmodule