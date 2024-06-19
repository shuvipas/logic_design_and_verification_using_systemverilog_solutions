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
  } st,nst;
  always_ff @(posedge clk, posedge rst) begin
    if (rst) st <= A;
    else st <= nst;
  end

  always_comb begin

    case (st)
      A: nst = x ? C : B;
      B: nst = x ? C : B;
      C: nst = x ? C : A;
      default nst<= A;
    endcase

  end
  always_comb begin
    unique case (st)
        A: {y,z} = x ? 2'b11 : 2'b01;
        B: {y,z} = 2'b10;
        C: {y,z} = x ? 2'b01 : 2'b10;
        
      endcase
  end

  //assign y = x & ~st[0] | ~x & st[1], z = ~st[1] | x & st[0];

endmodule


module tb_p3_5;
  logic x, clk, rst, y, z;

  p3_4 mut (.*);

  initial begin
    clk = 0;
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
    x<=1;
    #30;
    $display("st = A (reset)");
    x <= 1;
    //#2 $display($time, "  x = %b, yz = %b%b", x, y, z);

    #2 assert ({y, z} == 2'b11)
    else $display("failed: expected: 11 ");
    
    @(posedge clk);  // a 2 c
    $display("st = C");
    x <= 0;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 a
    $display("st = A");
    x <= 0;
    #2
      assert ({y, z} == 2'b01)
      else $display("failed: expected: 01 ");

    @(posedge clk);  // a 2 b
    $display("st = B");
    x <= 0;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");
    
    @(posedge clk);  // b 2 b
    $display("st = B");
    x <= 1;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");
    
    @(posedge clk);  // b 2 c
    $display("st = C");
    x <= 1;
    #2
      assert ({y, z} == 2'b01)
      else $display("failed: expected: 01 ");
    /*
    @(posedge clk);  // c 2 c
    $display("st = C");
    x <= 1;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");
*/
    #45 $finish;


  end

endmodule
