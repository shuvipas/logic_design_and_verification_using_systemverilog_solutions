
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
  logic [16:0] add_out;

  enum bit {
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
    else if (~ldn) sum <= add_out[15:0];
    else if (~cln) sum <= '0;
  end

  always_comb begin
    add_out = ina + sum;
    overflow = add_out[16];
    err = (st == sERR) ? 1'b1 : 1'b0;
    ldn = ~((st == sA & ~gon) | (st == sB & ~in_aeq));
    cln = ~(st == sB & ~in_aeq) | err;
    done = ~(st == sB & in_aeq);
    in_aeq = ina == '0;

  end





endmodule
