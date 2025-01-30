module fsm_prob_a (
    input  logic clk,
    rstn,
    i,
    j,
    output logic x,
    y
);
  logic [1:0] st_out;

  enum logic [1:0] {
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
        B: state <= j ? C : D;
        C: state <= i ? B : j ? C : D;
        D: state <= i ? D : j ? C : A;
        default: state <= A;
      endcase
    end
  end
  always_comb begin
    case (state)
      A: st_out = i ? 2'b11 : 2'b10;
      B: st_out = j ? 2'b01 : 2'b10;
      C: st_out = i ? 2'b0 : j ? 2'b10 : 2'b11;
      D: st_out = i ? 2'b0 : j ? 2'b10 : 2'b00;
      default: st_out = 2'b00;
    endcase
  end
  assign x = st_out[1], y = st_out[0];

endmodule

