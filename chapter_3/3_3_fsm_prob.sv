module fsm_prob_b (
    input  logic clk,
    rstn,
    i,
    j,
    output logic x,
    y
);
  logic [1:0] st_out;

  enum {
    A,
    B,
    C,
    D
  } state;
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) state <= A;
    else begin
      case (state)
        A: state <= i ? B : A;
        B: state <= i ? C : D;
        C: state <= i ? B : j ? C : D;
        D: state <= i ? D : j ? C : A;
        default: state <= A;
      endcase
    end
  end
  always_comb begin
    unique case (state)
      A: st_out = 2'b11;
      B: st_out = 2'b01;
      C: st_out = 2'b10;
      D: st_out = 2'b10;

    endcase
  end
  assign {x, y} = st_out;

endmodule


module tb_fsm_prob_b;
  logic clk, rstn, i, j, x, y;

  fsm_prob_b mut (.*);


  initial begin

    clk  = 0;
    rstn = 0;
    #1 rstn <= 1;
    forever #5 clk = ~clk;

  end
  always @(negedge clk)
    $display(
        $time, "  ij = %b%b, xy = %b%b", i, j, x, y
    );  //negedge to print the corrent state io
  initial begin
    i <= 1;
    j <= 1;


    @(posedge clk);  // a 2 b
    #2
      assert ({x, y} == 2'b01)
      else $display("failed: expected: 01 ");
    j <= 0;
    @(posedge clk);  // b 2 d
    #2
      assert ({x, y} == 2'b10)
      else $display("failed: expected: 10 ");
    i <= 0;
    j <= 1;
    @(posedge clk);  // d 2 c
    #2
      assert ({x, y} == 2'b10)
      else $display("failed: expected: 10 ");

    @(posedge clk);  // c 2 c
    #2
      assert ({x, y} == 2'b10)
      else $display("failed: expected: 10 ");
    j <= 0;
    @(posedge clk);  // c 2 d
    #2
      assert ({x, y} == 2'b10)
      else $display("failed: expected: 10 ");
    i <= 1;
    @(posedge clk);  // d 2 d
    #2
      assert ({x, y} == 2'b10)
      else $display("failed: expected: 10 ");
    i <= 0;
    @(posedge clk);  // d 2 a
    #2
      assert ({x, y} == 2'b11)
      else $display("failed: expected: 11 ");
    @(posedge clk);  // a 2 a

    #2
      assert ({x, y} == 2'b11)
      else $display("failed: expected: 11 ");

    #2 $finish;


  end

endmodule
