
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

  logic [3:0] change, between;

  assign cough_up_more = (cost > paid) ? 1'b1 : 1'b0;
  assign exact_amount = (cost == paid) ? 1'b1 : 1'b0;

 
  always_comb begin
    first_coin = 3'b0;
    second_coin = 3'b0;
    remaining = 3'b0;
    if (~exact_amount & ~cough_up_more) begin
 
     change = paid -cost;
      if (change >= 3'b101 & quarters >= 2'b1) first_coin = 3'b101;
      else if (change >= 3'b10 & dimes >= 2'b1) first_coin = 3'b10;
      else if (change >= 1'b1 & nickels >= 2'b1) first_coin = 3'b1;

      between = change - first_coin;

      if (between >= 3'b101 & quarters >= 2'b10) second_coin = 3'b101;
      else if (between >= 3'b10 & dimes >= 2'b10) second_coin = 3'b10;
      else if (between >= 1'b1 & nickels >= 2'b10) second_coin = 3'b1;
      remaining = between - second_coin;
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
    cost = 4'b101;  // cost is 10 (50 cents)
    paid = 4'b101;  // paid is 10 (50 cents)
    quarters = 2'd2;  // 2 quarters available
    dimes = 2'd1;  // 1 dime available
    nickels = 2'd3;  // 3 nickels available
    #10ns;
    
    assert (exact_amount == 1'b1)
    else $display("Test Case 1 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 1 failed: cough_up_more");
    assert (first_coin == 3'b0)
    else $display("Test Case 1 failed: first_coin");  // Expect a nickel
    assert (second_coin == 3'b0)
    else $display("Test Case 1 failed: second_coin");  // Expect another nickel
    assert (remaining == 4'b0)
    else $display("Test Case 1 failed: remaining");
    
    //$display("cost =%b ,paid =%b , quarters =%b ,dimes =%b ,nickels=%b ",cost ,paid , quarters ,dimes ,nickels);
    //$display("exact_amount =%b ,cough_up_more =%b ,first_coin =%b ,second_coin =%b ,remaining =%b",exact_amount ,cough_up_more ,first_coin ,second_coin ,remaining);


    // Test Case 2: Need change
    cost = 4'b1000;  // cost is 8 (40 cents)
    paid = 4'b1010;  // paid is 10 (50 cents)
    quarters = 2'b10;  // 2 quarters available
    dimes = 2'b1;  // 1 dime available
    nickels = 2'b11;  // 3 nickels available
    #10ns;
    
    assert (exact_amount == 1'b0)
    else $display("Test Case 2 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 2 failed: cough_up_more");
    assert (first_coin == 3'b10)
    else $display("Test Case 2 failed: first_coin");  // Expect a nickel
    assert (second_coin == 3'b0)
    else $display("Test Case 2 failed: second_coin");  // Expect another nickel
    assert (remaining == 4'b0)
    else $display("Test Case 2 failed: remaining");
    
    //$display("cost =%b ,paid =%b , quarters =%b ,dimes =%b ,nickels=%b ",cost ,paid , quarters ,dimes ,nickels);
    //$display("exact_amount =%b ,cough_up_more =%b ,first_coin =%b ,second_coin =%b ,remaining =%b",exact_amount ,cough_up_more ,first_coin ,second_coin ,remaining);


    // Test Case 3: Paid less than cost
    cost = 4'b1010;  // cost is 10 (50 cents)
    paid = 4'b101;  // paid is 5 (25 cents)
    quarters = 2'b10;
    dimes = 2'b1;  
    nickels = 2'b11;  
    #10ns;
    assert (exact_amount == 1'b0)
    else $display("Test Case 3 failed: exact_amount");
    assert (cough_up_more == 1'b1)
    else $display("Test Case 3 failed: cough_up_more");

//    $display("cost =%b ,paid =%b , quarters =%b ,dimes =%b ,nickels=%b ",cost ,paid , quarters ,dimes ,nickels);
  //  $display("exact_amount =%b ,cough_up_more =%b ,first_coin =%b ,second_coin =%b ,remaining =%b",exact_amount ,cough_up_more ,first_coin ,second_coin ,remaining);


    // Test Case 4: Different coin distribution
    cost = 4'b101; 
    paid = 4'b1010;  
    quarters = 2'b0; 
    dimes = 2'b1;  
    nickels = 2'b10;
    #10ns;
    
    assert (exact_amount == 1'b0)
    else $display("Test Case 4 failed: exact_amount");
    assert (cough_up_more == 1'b0)
    else $display("Test Case 4 failed: cough_up_more");
    assert (first_coin == 3'b10)
    else $display("Test Case 4 failed: first_coin"); 
    assert (second_coin == 3'b1)
    else $display("Test Case 4 failed: second_coin");  
    assert (remaining == 4'b10)
    else $display("Test Case 4 failed: remaining");
    
   // $display("cost =%b ,paid =%b , quarters =%b ,dimes =%b ,nickels=%b ",cost ,paid , quarters ,dimes ,nickels);
    //$display("exact_amount =%b ,cough_up_more =%b ,first_coin =%b ,second_coin =%b ,remaining =%b",exact_amount ,cough_up_more ,first_coin ,second_coin ,remaining);



    $finish;

  end

endmodule
