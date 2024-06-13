//problem 2.1

`timescale 1ps / 1ps
module prob2_1;
  logic a, b;
  initial begin
    a = 0;
    b = 1;
    #3ps;
    a = ~a;
    b = ~b;
    #3ps b = ~b;
    #2ps a = ~a;
    #3ps;
    a = ~a;
    b = ~b;
    #1ps a = ~a;
    #4ps;
    $finish;
  end
endmodule


