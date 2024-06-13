module char_type (
    input logic [6:0] code,
    output logic is_cap,
    is_lc,
    is_num,
    is_printable
);

  always_comb begin
    is_cap = 1'b0;
    is_lc = 1'b0;
    is_num = 1'b0;
    is_printable = 1'b0;
    if (code > 7'h1f & code < 7'h7f) begin
      is_printable = 1'b1;
      if (code > 7'h2f & code < 7'h3a) is_num = 1'b1;
      else if (code > 7'h40 & code < 7'h5b) is_cap = 1'b1;
      else if (code > 7'h60 & code < 7'h7b) is_lc = 1'b1;
    end
  end
endmodule


`timescale 1ns / 1ps
module tb_char_type;
  logic [6:0] code;
  logic is_cap, is_lc, is_num, is_printable;

  char_type dut (.*);

  initial begin
    $display("code      char is_cap is_lc is_num is_printable");
    for (code = 7'b0; code <= 7'h7f; code++) begin
      $display("code = %b     %c %b %b %b %b", code, code, is_cap, is_lc, is_num, is_printable);
    end
    $finish;
  end

endmodule
