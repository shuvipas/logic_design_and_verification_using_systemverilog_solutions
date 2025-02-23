
module top73;
  logic clk, rstn, i, j, x, y;

  fsm_prob_b dut (.*);
  tb3_3 tb (.*);

  initial
  begin
    $monitor($time, " current state: %b, input: ij %b%b output: xy = %b%b", dut.state, i, j, x, y);
    $dumpfile("top73.vcd");
    $dumpvars(0, top73);
    clk  = 0;
    rstn = 0;
    rstn <= #1 1; 
    forever
      #5 clk = ~clk;
  end
endmodule



module tb3_3 (
    input  logic clk,
    output logic i,
    j
  );
  initial
  begin
    i = 1;
    j = 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    i = 0;
    j = 1;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    j = 0;
    @(posedge clk);
    i = 1;
    @(posedge clk);
    i = 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $finish;
  end

endmodule
