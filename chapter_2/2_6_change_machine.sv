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
  logic [2:0] coin;
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
      ); */

          coin = 3'b0;
    if (change > 3'b101 & quarters > 2'b1) coin = 3'b101;
    else if (change > 3'b10 & dimes > 2'b1) coin = 3'b10;
    else if (change > 1'b1 & nickels > 2'b1) coin = 3'b1;
    first_coin =coin;



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

            coin = 3'b0;
    if (change > 3'b101 & quarters_temp > 2'b1) coin = 3'b101;
    else if (change > 3'b10 & dimes_temp > 2'b1) coin = 3'b10;
    else if (change > 1'b1 & nickels_temp > 2'b1) coin = 3'b1;
    second_coin =coin;

      remaining = paid - cost - first_coin - second_coin;
    end


  end


endmodule


