module serial_bcd_adder (
    input logic [3:0] a,
    b,
    input logic start,
    done,
    rstn,
    clk,
    output logic [3:0] sum
);
  logic [4:0] adder_sum;
  logic [3:0] sub_sum;
  logic sub10;
  logic cin, en_ff, en;
  always_comb begin
    adder_sum = a + b + cin;
    sub10 = adder_sum[4] | adder_sum[3]&(adder_sum[2]|adder_sum[1]); //carry out or adder_sum > 9
    sub_sum = adder_sum[3:0] + 4'b0110;  // adder sum - 10
    sum = en ?(sub10 ? sub_sum : adder_sum): 4'b0;
  end

  assign en = ~done &(start | en_ff);

  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) cin <= 1'b0;
    else cin <= (start|done) ? 1'b0 : sub10;
  end
  always_ff @(posedge clk , negedge rstn) begin 
    if (~rstn) en_ff <= 1'b0;
    else en_ff <= en;
  end

endmodule



`timescale 1ns / 1ps
module tb_serial_bcd_adder;

  logic [3:0] a, b, sum;
  logic start, done, rstn, clk;

  serial_bcd_adder dut (.*);

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    rstn = 0;
    a = 0;
    b = 0;
    start = 0;
    done = 0;

    #2 rstn = 1;
  end

  initial begin
    $display("test bench begin");
    @(posedge clk);
    start = 1'b1;
    a = 4'b0011;  // a = 3
    b = 4'b0101;  // b = 5
    #1 check_result(.sum(sum), .expected_sum(4'b1000));
    @(posedge clk);
    start = 1'b0;
    done = 1'b1;
    @(posedge clk);
    done = 1'b0;
    
    @(posedge clk);
    start = 1'b1;  // 123+480 = 405
    a = 4'b0001;
    b = 4'b0100;
    #1 check_result(.sum(sum), .expected_sum(4'b0101));

    @(posedge clk);
    start = 1'b0;
    a = 4'b0010;
    b = 4'b1000;
    #1 check_result(.sum(sum), .expected_sum(4'b0));

    @(posedge clk);
    a = 4'b0011;
    b = 4'b0;
    #1 check_result(.sum(sum), .expected_sum(4'b0100));

    @(posedge clk);
    done = 1'b1;

    $display("test bench finished");
  end

  task check_result(input logic [3:0] sum, expected_sum);
    if (sum != expected_sum) begin
      $display("Error: Expected sum= %0d, Got sum =%0d", expected_sum, sum);
    end
  endtask

endmodule
