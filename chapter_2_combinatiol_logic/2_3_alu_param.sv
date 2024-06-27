typedef enum logic [1:0] {
  ADD = 2'b00,
  AND = 2'b01,
  OR  = 2'b10,
  XOR = 2'b11
} operation;
module alu_param #(
    parameter W = 8
) (
    input logic [W-1:0] a,
    b,  // 2 signed numbers
    input operation op,
    input logic cin,
    output logic [W-1:0] res,
    output logic cout,
    n,
    z,
    v  // n = negative, v= overflow, z = zero 
);
  always_comb begin
    n = 1'b0;
    z = 1'b0;
    v = 1'b0;
    cout = 1'b0;
    unique case (op)
      ADD: begin

        {cout, res} = a + b + cin;
        //res = a+b;
        //v = (~(a[W-1]^b[W-1]))^res[W-1];
        v = ((a[W-1] == b[W-1])) & (b[W-1] != res[W-1]);
        //cout = v;
      end
      AND: res = a & b;
      OR:  res = a | b;
      XOR: res = a ^ b;
    endcase
    z = ~|res;
    n = res[W-1];
  end

endmodule


`timescale 1ps / 1ps
module tb_alu_param;

  operation op;
  logic cout, n, z, v, cin;
  logic [2:0] a, b, res, expected_res;

  logic [6:0] count;
  logic expected_cout, expected_n, expected_z, expected_v;

  alu_param #(3) dut (.*);

  always_comb begin
    cin = count[0];
    a   = count[3:1];
    b   = count[6:4];
  end

  initial begin
    //$monitor("%s: a = %b, b = %b, cin = %b\nnzv = %b%b%b, res = %b ", op.name, a, b, cin, n, z, v,res);
    for (int i = ADD; i <= XOR; i++) begin
      op = operation'(i);
      for (count = '0; count <= 7'h3f; count++) begin
        #2;
        expected_res =
            alu_checker(a, b, cin, op, expected_cout, expected_n, expected_z, expected_v);
        if (res !== expected_res || cout !== expected_cout || n !== expected_n || z !== expected_z || v !== expected_v) begin
          $display(
              "Error: op=%s, a=%b, b=%b, cin=%b\n -> res=%b (expected %b), cout=%b (expected %b), n=%b (expected %b), z=%b (expected %b), v=%b (expected %b)",
              op.name, a, b, cin, res, expected_res, cout, expected_cout, n, expected_n, z,
              expected_z, v, expected_v);
        end
      end
    end
    $finish;
  end
  function logic [2:0] alu_checker(input logic [2:0] a, b, input logic cin, input operation op,
                                   output logic cout, output logic n, output logic z,
                                   output logic v);
    logic [3:0] temp_sum;
    cout = 0;
    v = 0;
    case (op)
      ADD: begin
        temp_sum = a + b + cin;
        cout = temp_sum[3];
        alu_checker = temp_sum[2:0];
        v = ~(a[2] ^ b[2]) & (a[2] ^ temp_sum[2]);
      end
      AND: alu_checker = a & b;
      OR:  alu_checker = a | b;
      XOR: alu_checker = a ^ b;
    endcase
    z = (alu_checker == 3'b000);
    n = alu_checker[2];
  endfunction

endmodule

