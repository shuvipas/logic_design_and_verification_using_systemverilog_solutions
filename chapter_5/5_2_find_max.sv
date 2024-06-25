

module find_max #(
    parameter W = 8
) (
    input logic start,
    clk,
    rstn,
    input logic [W-1:0] input_a,
    output logic done,
    output logic [W-1:0] max_val
);

  logic neg_e_detct, bigger;

  assign bigger = input_a > max_val;


  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) max_val <= '0;
    else begin
      if (start) max_val <= bigger ? input_a : max_val;
      else max_val <= '0;
    end
  end

  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) neg_e_detct <= 1'b0;
    else neg_e_detct <= start;
  end

  assign done = neg_e_detct & ~start;

endmodule

`timescale 1ps/1ps
module tb_find_max;
  logic start, clk, rstn, done;
  logic [3:0] input_a, max_val;

  find_max #(4) mut (.*);

  initial begin
    start = 0;
    clk   = 1;
    rstn  = 0;
    #1 rstn = 1;
    $monitor($time, "  start= %b, input_a= %b, max_val = %b, done = %b ", start, input_a, max_val,
             done);
  end
  always #5 clk = ~clk;

  initial begin
    @(posedge clk);
    start   <= 1;
    input_a <= 4'b10;

    @(posedge clk);
    input_a <= 4'b01;
    @(posedge clk);
    input_a <= 4'b11;

    @(posedge clk);
    input_a <= 4'b111;

    @(posedge clk);
    input_a <= 4'b0;

    @(posedge clk);
    input_a <= 4'b01;
    start   <= 0;
    @(posedge clk);
    input_a <= 4'b111;

    @(posedge clk);
    input_a <= 4'b0;

    #25 $finish;

  end


endmodule
