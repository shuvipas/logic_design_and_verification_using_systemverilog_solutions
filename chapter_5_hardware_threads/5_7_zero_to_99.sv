module decade_ctr (
    input logic clk,
    rstn,
    count_en,
    output logic cout,
    output logic [3:0] dcba
);
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) dcba <= 4'b0;
    else if (dcba[3] & (dcba[2] | dcba[1])) dcba <= 4'b0;
    else if (cout) dcba <= 4'b0;
    else if (count_en) begin
      dcba[0] <= ~dcba[0];
      dcba[1] <= ~dcba[3] & ~dcba[1] & dcba[0] | dcba[1] & ~dcba[0];
      dcba[2] <= ~dcba[3]&dcba[2]&~dcba[1]|~dcba[2]&dcba[1]&dcba[0]|dcba[2]&dcba[1]&~dcba[0];
      dcba[3] <= dcba[2] & dcba[1] & dcba[0] | dcba[3];
    end
  end
  assign cout = dcba[3] & dcba[0];

endmodule

module zero_to_99 (
    input logic clk,
    rstn,
    count_en,
    output logic cout,
    output logic [3:0] dcba10,
    dcba1
);

  logic cout_ones;
  decade_ctr ones (
      .dcba(dcba1),
      .cout(cout_ones),
      .*
  );
  decade_ctr tens (
      .dcba(dcba10),
      .count_en(cout_ones),
      .*
  );

endmodule


`timescale 1ps / 1ps

module tb_zero_to_99;

  logic clk, rstn, count_en, cout;
  logic [3:0] dcba10, dcba1;
  logic [8:0] count;
  zero_to_99 dut (.*);

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    rstn = 0;
    count_en = 1;
    count = 0;
    #7 rstn = 1;
  end

  initial begin
    automatic int i = 0;
    $display("test bench begin");
    while (i < 110) begin
      i++;
      @(posedge clk);
      if (count_en) count++;
      $display("count = %d, cout = %b, dcba10 = %b,dcba1= %b", count, cout, dcba10, dcba1);
      if (i % 13 == 0) begin
        count_en = 0;
      end else count_en = 1;


    end
    $display("test bench end");
    $finish;

  end

endmodule
