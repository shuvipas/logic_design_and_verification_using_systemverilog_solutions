module reg_with_benefits #(
    parameter W = 8
) (
    input logic [W -1:0] d,
    input logic rstn,
    clk,
    clr,
    ld,
    shl,
    shin,
    output logic [W-1:0] q
);

  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) q <= '0;
    else if (clr) q <= '0;
    else if (ld) q <= d;
    else if (shl) q <= {q[W-2:0], shin};
  end
endmodule

`timescale 1ps / 1ps
module tb_reg_with_benefits;
  logic [3:0] d, q;
  logic clk, rstn, clr, ld, shl, shin;
  reg_with_benefits #(.W(4)) dut (.*);




  always #5 clk = ~clk;

  initial begin
    $monitor($time, " d = %b, q= %b,  rstn= %b,clr= %b,ld= %b,shl= %b, shin= %b\n\n", d, q, rstn,
             clr, ld, shl, shin);

    clk = 0;
    d = 4'b1010;
    shin = 0;
    rstn = 0;
    ld = 1;
    clr = 0;
    shl = 0;
    #10 rstn = 1;
    ld = 1;
    #20 clr = 1;
    d = 4'b1111;
    #10 clr = 0;
    ld  = 1;
    shl = 1;
    #10 ld = 0;
    #50 $finish;
  end




endmodule
