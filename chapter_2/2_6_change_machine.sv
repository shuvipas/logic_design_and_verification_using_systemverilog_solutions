module next_coin (
    input  logic [3:0] change,
    input  logic [1:0] quarters,
    dimes,
    nickels,  //quarters=5, dimes=2,nickels=1
    output logic [2:0] coin
);
  always_comb begin
    coin = 3'b0;
    if (change > 3'b101 & quarters > 1'b1) coin = 3'b101;
    else if (change > 3'b10 & dimes > 1'b1) coin = 3'b10;
    else if (change > 1'b1 & nickels > 1'b1) coin = 3'b1;
  end
endmodule

module change_machine (
    input logic [3:0] cost,
    paid,  //all in nickels
    input logic [1:0] quarters,
    dimes,
    nickels,  //quarters=5, dimes=2,nickels=1
    output logic [2:0] first_coin,
    second_coin,
    output logic exact_amount,
    cough_up_more,
    output logic [3:0] remaining
);

  logic [3:0] change;
  // logic [2:0] coin;
  logic [1:0] quarters_temp, dimes_temp, nickels_temp;

  assign cough_up_more = (cost > paid) ? 1'b1 : 1'b0;
  assign exact_amount = (cost == paid) ? 1'b1 : 1'b0;

  assign change = cost - paid;

  always_comb begin

    remaining = 3'b0;
    if (~exact_amount & ~cough_up_more) begin
      /*    
      next_coin first (
          .change(change),
          .quarters(quarters),
          .dimes(dimes),
          .nickels(nickels),
          .coin(first_coin)
      ); 
      */


      if (change > 3'b101 & quarters > 2'b1) first_coin = 3'b101;
      else if (change > 3'b10 & dimes > 2'b1) first_coin = 3'b10;
      else if (change > 1'b1 & nickels > 2'b1) first_coin = 3'b1;
      else first_coin = 3'b0;



      unique case (first_coin)
        3'b1:   nickels_temp = nickels - 1'b1;
        3'b10:  dimes_temp = dimes - 1'b1;
        3'b101: quarters_temp = quarters - 1'b1;
      endcase

      /*
      next_coin second (
          .change(change),
          .quarters(quarters_temp),
          .dimes(dimes_temp),
          .nickels(nickels_temp),
          .coin(second_coin)
      );
      */

      if (change > 3'b101 & quarters_temp > 2'b1) second_coin = 3'b101;
      else if (change > 3'b10 & dimes_temp > 2'b1) second_coin = 3'b10;
      else if (change > 1'b1 & nickels_temp > 2'b1) second_coin = 3'b1;
      else second_coin = 3'b0;
      remaining = paid - cost - first_coin - second_coin;
    end

  end
endmodule


`timescale 1ps / 1ps

module tb_change_machine;

  logic [3:0] cost, paid, remaining;  //all in nickels
  logic [1:0] quarters, dimes, nickels;  //quarters=5, dimes=2,nickels=1
  logic [2:0] first_coin, second_coin;
  logic exact_amount, cough_up_more;

  change_machine dut (.*);

  initial begin
    // Test Case 1: Exact amount
    cost = 4'd10;  // cost is 10 (50 cents)
    paid = 4'd10;  // paid is 10 (50 cents)
    quarters = 2'd2;  // 2 quarters available
    dimes = 2'd1;  // 1 dime available
    nickels = 2'd3;  // 3 nickels available
    #10;
    assert (exact_amount == 1'b1)
    else $display("Test Case 1 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 1 failed: cough_up_more");
    assert (first_coin == 3'b0)
    else $display("Test Case 2 failed: first_coin");  // Expect a nickel
    assert (second_coin == 3'b0)
    else $display("Test Case 2 failed: second_coin");  // Expect another nickel
    assert (remaining == 4'b0)
    else $display("Test Case 2 failed: remaining");


    // Test Case 2: Need change
    cost = 4'd8;  // cost is 8 (40 cents)
    paid = 4'd10;  // paid is 10 (50 cents)
    quarters = 2'd2;  // 2 quarters available
    dimes = 2'd1;  // 1 dime available
    nickels = 2'd3;  // 3 nickels available
    #10;
    assert (exact_amount == 1'b0)
    else $display("Test Case 2 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 2 failed: cough_up_more");
    assert (first_coin == 3'b1)
    else $display("Test Case 2 failed: first_coin");  // Expect a nickel
    assert (second_coin == 3'b1)
    else $display("Test Case 2 failed: second_coin");  // Expect another nickel
    assert (remaining == 4'd2)
    else $display("Test Case 2 failed: remaining");

    // Test Case 3: Paid less than cost
    cost = 4'd10;  // cost is 10 (50 cents)
    paid = 4'd5;  // paid is 5 (25 cents)
    quarters = 2'd2;  // 2 quarters available
    dimes = 2'd1;  // 1 dime available
    nickels = 2'd3;  // 3 nickels available
    #10;
    assert (exact_amount == 1'b0)
    else $display("Test Case 3 failed: exact_amount");
    assert (cough_up_more == 1'b1)
    else $display("Test Case 3 failed: cough_up_more");

    // Test Case 4: Different coin distribution
    cost = 4'd15;  // cost is 15 (75 cents)
    paid = 4'd20;  // paid is 20 (100 cents)
    quarters = 2'd3;  // 3 quarters available
    dimes = 2'd1;  // 1 dime available
    nickels = 2'd2;  // 2 nickels available
    #10;
    assert (exact_amount == 1'b0)
    else $display("Test Case 4 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 4 failed: cough_up_more");
    assert (first_coin == 3'b101)
    else $display("Test Case 4 failed: first_coin");  // Expect a quarter
    assert (second_coin == 3'b0)
    else $display("Test Case 4 failed: second_coin");  // No second coin expected
    assert (remaining == 4'd5)
    else $display("Test Case 4 failed: remaining");


    $finish;

  end

endmodule
