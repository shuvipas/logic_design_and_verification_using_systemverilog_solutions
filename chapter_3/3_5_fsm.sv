module p3_5 (
    input  logic x,
    clk,
    rst,
    output logic y,
    z
);

  enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b11
  }
      st, nst;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) st <= A;
    else st <= nst;
  end

  always_comb begin

    case (st)
      A: nst = x ? C : B;
      B: nst = x ? C : B;
      C: nst = x ? C : A;
    endcase

  end
  assign y = st[0], z = ~st[0];

endmodule


module tb_p3_5;
  logic x, clk, rst, y, z;

  p3_4 mut (.*);

  initial begin
    clk = 1;
    rst = 1;
    #3 rst = 0;
  end

  always #5 clk = ~clk;
  always @(negedge clk)
    $display(
        $time, "  x = %b, yz = %b%b", x, y, z
    );  //negedge to print the corrent state io

  initial begin
    @(negedge rst);
    $display("st = A (reset)");
    x <= 1;
    $display($time, "  x = %b, yz = %b%b", x, y, z);
    #2 assert ({y, z} == 2'b01)
    else $display("failed: expected: 01 ");
    @(posedge clk);  // a 2 c
    $display("st = C");
    x <= 0;
    #2 assert ({y, z} == 2'b10)
    else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 a
    #2 $display("st = A");
    x <= 0;
    #2 assert ({y, z} == 2'b01)
    else $display("failed: expected: 01 ");

    @(posedge clk);  // a 2 b
    $display("st = B");
    x <= 0;
    #2 assert ({y, z} == 2'b10)
    else $display("failed: expected: 10 ");
    @(posedge clk);  // b 2 b
    $display( "st = B");
    x <= 1;
    #2 assert ({y, z} == 2'b10)
    else $display("failed: expected: 10 ");
    @(posedge clk);  // b 2 c
    $display( "st = C");
    x <= 1;
    #2 assert ({y, z} == 2'b10)
    else $display("failed: expected: 10 ");
    @(posedge clk);  // c 2 c
    $display( "st = C");
    x <= 1;
    #2 assert ({y, z} == 2'b10)
    else $display("failed: expected: 10 ");

    #5 $finish;


  end

endmodule
