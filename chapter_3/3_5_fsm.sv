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
  } st;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) st <= A;
    else begin
      case (st)
        A: st <= x ? C : B;
        B: st <= x ? C : B;
        C: st <= x ? C : A;
      endcase

    end
  end

  assign y = x & ~st[0] | ~x & st[1], z = ~st[1] | x & st[0];

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
    //#2 $display($time, "  x = %b, yz = %b%b", x, y, z);

    assert ({y, z} == 2'b11)
    else $display("failed: expected: 11 ");
    
    @(posedge clk);  // a 2 c
    $display("st = C");
    x <= 0;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 a
    #2 $display("st = A");
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
    #5 $finish;


  end

endmodule
