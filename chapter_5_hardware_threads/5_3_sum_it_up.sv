// i need to design the module again
module sum_it_up (
    input logic clk,
    rstn,
    gon,
    input logic [15:0] ina,
    output logic done,
    err,
    output logic [15:0] sum
);
  logic ldn, cln, in_aeq, overflow;
  logic [15:0] add_out;

  enum bit [1:0] {
    sA,
    sB,
    sERR
  } st;

  // state machine
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) st <= sA;
    else begin
      if ((st == sA & gon) | (st == sB & in_aeq)) st <= sA;
      else if ((st == sA & ~gon) | (st == sB & ~in_aeq)) st <= sB;
      else if ((st == sERR & ~gon) | overflow) st <= sERR;
    end
  end

  //sum register

  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) sum <= '0;
    else if (~ldn) sum <= add_out;
    else if (~cln) sum <= '0;
  end

  always_comb begin
    {overflow,add_out} = ina + sum;
//    overflow = add_out[16];
    err = (st == sERR) ? 1'b1 : 1'b0;
    in_aeq = ina == '0;
    ldn = ~(((st == sA) & ~gon) | ((st == sB) & ~in_aeq));
    cln = ~(st == sB & ~in_aeq) | err;
    done = (st == sB & in_aeq) & ~err;

  end

endmodule

`timescale 1ns / 1ps
module tb_sum_it_up;

  logic clk, rstn, gon, done, err;
  logic [15:0] ina, sum;


  sum_it_up dut (.*);

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end


  initial begin
    rstn = 0;
    gon <= 0;
    ina <= 16'b0;
    #2;
    rstn = 1;

  end


  initial begin
    $monitor($time, "go = %b ina = %d  sum=%0d, err=%0b, done=%0b", gon, ina, sum, err, done);

    // Normal addition, no overflow
    @(negedge clk);
    gon = 1;
    ina = 16'ha;  //10
    @(negedge clk);
    ina = 16'h14;  //20
    @(negedge clk);
    ina = 16'h1e;  //30
    @(negedge clk);
    ina = 16'h0;
    @(negedge clk);
    gon = 0;
    #10;
    check_result(16'h3c, 0, 1, "Normal addition, no overflow");

    // Test 2: Addition with overflow
    @(negedge clk);
    gon = 1;
    ina = 16'hffff;
    @(negedge clk);
    ina = 16'ha;  //10
    @(negedge clk);
    ina = 16'h5;
    @(negedge clk);
    ina = 16'h0;
    @(negedge clk);
    gon = 0;
    #10;
    check_result(16'h0, 1, 0, "With overflow");


    $finish;
  end

  // Checker function
  task check_result(input logic [15:0] expected_sum, input logic expected_err,
                    input logic expected_done, input string test_name);
    if (sum !== expected_sum || err !== expected_err || done !== expected_done)
      $display(
          "ERROR in %s: Expected sum=%0d, err=%0b, done=%0b; Got sum=%0d, err=%0b, done=%0b",
          test_name,
          expected_sum,
          expected_err,
          expected_done,
          sum,
          err,
          done
      );
    else $display("%s passed.", test_name);

  endtask

endmodule
