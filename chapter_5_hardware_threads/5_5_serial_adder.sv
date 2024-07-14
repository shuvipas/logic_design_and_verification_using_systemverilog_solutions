module serial_adder (
    input logic a,
    b,
    rstn,
    clk,
    output logic [5:0] sum,
    output logic done,
    cout,
    zwro
);

  logic rst_carry, cin, c_out_adder,sum_adder ;
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
  assign rst_carry = st == s6;

  always_ff @(posedge clk, negedge rstn) begin
    if (~rsn) cin <= 1'b0;
    else cin <= rst_carry ? 1'b0 : c_out_adder;
  end

//data path

//sum register
  always_ff @(posedge clk, negedge rstn) begin
        if (~rstn) sum <= 6'b0;
    else
 
  end


endmodule
