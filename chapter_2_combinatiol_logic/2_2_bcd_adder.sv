module bcd_adder (
    input logic [3:0] a,
    b,
    input logic cin,
    output logic [3:0] sum,
    output logic cout
);
  logic [3:0] t_sum;
  always_comb begin
    t_sum = a + b + cin;
    cout = t_sum > 4'b1001? 1'b1:1'b0; 
    if (cout) begin
      sum  = t_sum + 4'b0110;// == - 4'b1010 (its the twos comlument)
    end else begin
      sum  = t_sum;
      
    end
  end
endmodule

`timescale 1ns / 1ps
module tb_bcd_adder;
  logic [4:0] sum;

  logic [9:0] count;

  bcd_adder dut (
      .a(count[8:5]),
      .b(count[4:1]),
      .cin(count[0]),
      .cout(sum[4]),
      .sum(sum[3:0])
  );


  initial begin
    $display("tb_bcd_adder run");
    //    $monitor("a = %b, b = %b, cin = %b cout,sum = %b", count[8:5], count[4:1], count[0], bcd2bin(
    //           sum));
    for (count = 10'b0; count <= 10'h3ff; count++) begin
      if (count[8:5] <= 4'b1001 & count[4:1] <= 4'b1001) begin
        #1ns;
        if (count[8:5] + count[4:1] + count[0] != bcd2bin(sum))
          $display(
              "oops a = %b, b = %b, cin = %b bcd2bin =%b, cout,sum = %b",
              count[8:5],
              count[4:1],
              count[0],
              bcd2bin(
                  sum
              ),
              sum
          );
      end

    end
    $finish;
  end

  function logic [4:0] bcd2bin(logic [4:0] in);
    if (in[4]) bcd2bin = 5'ha + in[3:0];
    else bcd2bin = in[3:0];
  endfunction

endmodule

