// i need to come back to this and write a test bench
module serial_adder (
    input logic a,
    b,
    start,
    rstn,
    clk,
    output logic [5:0] sum,
    output logic done,
    cout,
    zero, 
    neg,
    twos_overflow
);

  logic rst_carry, cin, shift, c_out_adder, sum_adder;
  enum logic [2:0] {
    s0,
    s1,
    s2,
    s3,
    s4,
    s5,
    s6
  } st;

  // state mechine
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) st <= s0;
    else
      case (st)
        s0: st <= start ? s1 : s0;
        s1: st <= s2;
        s2: st <= s3;
        s3: st <= s4;
        s4: st <= s5;
        s5: st <= s6;
        s6: st <= start ? s1 : s0;
        default: st <= s0;
      endcase
  end
  
  //data path
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) cin <= 1'b0;
    else cin <= rst_carry ? 1'b0 : c_out_adder;
  end


  simple_adder a1 (
      a,
      b,
      cin,
      sum_adder,
      c_out_adder
  );
  always_comb begin
    rst_carry = 1'b0;
    done = 1'b0;
    shift = 1'b1;
    if (st == s6) begin
      rst_carry = 1'b1;
      done = 1'b1;
      shift = 1'b0;
      zero = sum == 6'b0;
      twos_overflow = a^b |a^sum[5]; // == ~(~(a^b)&~(a^sum[6]))
      neg = twos_overflow? cout: sum[5];
    end
  end

  //sum register
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) sum <= 6'b0;
    else sum <= shift ? {sum_adder, sum[5:1]} : 6'b0;  // shift =1, clear for ~shift
  end


endmodule

module simple_adder (
    input  logic a,
    b,
    cin,
    output logic sum,
    cout
);
  assign sum = a ^ b ^ cin, cout = a & b | a & cin | b & cin;

endmodule
