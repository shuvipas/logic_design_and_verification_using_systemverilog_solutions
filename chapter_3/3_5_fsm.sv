module p3_5 (
    input  logic x,
    clk,
    rst,
    // output logic [1:0] state,
    output logic y,
    z
);

  enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b11
  }
      st, nst;
  // assign state[0] = st[0],state[1] = st[1];
  always_ff @(posedge clk, posedge rst) begin
    if (rst) st <= A;
    else st <= nst;
  end

  always_comb begin

    case (st)
      A: nst = x ? C : B;
      B: nst = x ? C : B;
      C: nst = x ? C : A;
      default nst = A;
    endcase

  end

  always_comb begin
    case (st)
      A: {y, z} = x ? 2'b11 : 2'b01;
      B: {y, z} = 2'b10;
      C: {y, z} = x ? 2'b01 : 2'b10;
      default {y, z} = 2'b00;
    endcase
  end
  // more compact way:
  //assign y = x & ~st[0] | ~x & st[1], z = ~st[1] | x & st[0];

endmodule


module tb_p3_5;
  logic x, clk, rst, y, z;
  //logic [1:0] state;

  p3_5 mut (.*);

  initial begin
    clk = 0;
    rst = 1;
    #1 rst = 0;
  end

  always #5 clk = ~clk;
  always @(negedge clk)
    $display(
        $time, " st = %s  x = %b, yz = %b%b", mut.st.name, x, y, z
    );  //negedge to print the corrent state io

  initial begin
    @(negedge rst);
    x <= 1;


    #2 $display($time, " st = %s (restart)  x = %b, yz = %b%b", mut.st.name, x, y, z);

    assert ({y, z} == 2'b11)
    else $display("failed: expected: 11 ");

    @(posedge clk);  // a 2 c
    x <= 0;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 a
    x <= 0;
    #2
      assert ({y, z} == 2'b01)
      else $display("failed: expected: 01 ");

    @(posedge clk);  // a 2 b
    x <= 0;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // b 2 b
    x <= 1;
    #2
      assert ({y, z} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // b 2 c
    x <= 1;
    #2
      assert ({y, z} == 2'b01)
      else $display("failed: expected: 01 ");

    #15 $finish;


  end

endmodule
