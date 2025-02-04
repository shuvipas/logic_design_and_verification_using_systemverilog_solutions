module top72;

logic clk, rstn,i,j,x,y;

fsm_prob_a dut(.*);
tb3_2 tb(.*);

initial begin
    $monitor("current state: %b, output: xy = %b%b", dut.state,x,y);
    $dumpfile("top72.vcd");
    $dumpvars(0, top72);
    clk =0;
    rstn =0;
    rstn <= #1  1;
    forever #5 clk = ~clk;
    
end
endmodule


module tb3_2(input logic clk, output logic i,j);

initial begin
    $display( "start tb3_2");
    i =0;
    j=0;
    @(posedge clk);
    i=1;
    @(posedge clk);
    j=1;
    @(posedge clk);
    i=0;
    @(posedge clk);
    i=1;
    @(posedge clk);
    j=0;
    @(posedge clk);
    @(posedge clk);
    i=0;
    j=1;
    @(posedge clk);
    j=0;
    @(posedge clk);
    i=0;
    @(posedge clk);
    #1 $finish;
end  

endmodule