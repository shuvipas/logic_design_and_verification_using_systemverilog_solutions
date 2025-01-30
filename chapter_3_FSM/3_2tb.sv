
module tb_fsm_prob_a;
  logic clk, rstn, i, j, x, y;

  fsm_prob_a mut (.*);


  initial begin
    $monitor($time, "  ij = %b%b, xy = %b%b", i, j, x, y);
    clk  = 0;
    rstn = 0;
    #1 rstn <= 1;
    forever #5 clk = ~clk;
  end
  initial begin
    i <= 1;
    j <= 1;
    @(posedge clk);  // a 2 b
    assert ({x, y} == 2'b11)
    else $display("failed: expected: 11 ");
    j <= 0;
    @(posedge clk);  // b 2 d
    assert ({x, y} == 2'b10)
    else $display("failed: expected: 10 ");
    i <= 0;
    j <= 1;
    @(posedge clk);  // d 2 c
    assert ({x, y} == 2'b10)
    else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 c
    assert ({x, y} == 2'b10)
    else $display("failed: expected: 10 ");
    j <= 0;
    @(posedge clk);  // c 2 d
    assert ({x, y} == 2'b11)
    else $display("failed: expected: 11 ");
    i <= 1;
    @(posedge clk);  // d 2 d
    assert ({x, y} == 2'b0)
    else $display("failed: expected: 00 ");
    i <= 0;
    @(posedge clk);  // d 2 a
    assert ({x, y} == 2'b0)
    else $display("failed: expected: 00 ");
    @(posedge clk);  // a 2 a
    assert ({x, y} == 2'b10)
    else $display("failed: expected: 10 ");

    #2 $finish;


  end

endmodule
