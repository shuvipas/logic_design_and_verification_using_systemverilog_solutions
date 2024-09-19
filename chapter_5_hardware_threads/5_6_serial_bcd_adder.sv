module serial_bcd_adder (
    input logic [3:0] a,
    b,
    input logic start,
    done,
    rstn,
    clk,
    output logic [3:0] sum
);
  logic [4:0] adder_sum;
  logic [3:0] sub_sum;
  logic sub10;
  logic cin;
  always_comb begin
    adder_sum = a + b + cin;
    sub10 = adder_sum[4] | adder_sum[3]&(adder_sum[2]|adder_sum[1]); //carry out or adder_sum > 9
    sub_sum = adder_sum[3:0] + 4'b0110;  // adder sum - 10
    sum = done ? 4'b0 : (sub10 ? sub_sum : adder_sum);
  end

  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) cin <= 1'b0;
    else cin <= done ? 1'b0 : sub10;
  end

endmodule

module tb_serial_bcd_adder;

endmodule
