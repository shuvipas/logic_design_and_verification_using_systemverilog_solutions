//chapter 1

`timescale 1ns / 1ps
module prob_1_2;
  logic out;
  logic [3:0] in, count;
  // integer count;
  four_bit_test uut (
      .a  (in[0]),
      .b  (in[1]),
      .c  (in[2]),
      .d  (in[3]),
      .out(out)
  );
  //driver
  initial begin
    $monitor("abcd = %b, out = %b", in, out);

    for (count = 0; count <= 4'b1111; count++) begin
      #1ns in = count;
    end
    $finish;
  end
  //moniter


endmodule
