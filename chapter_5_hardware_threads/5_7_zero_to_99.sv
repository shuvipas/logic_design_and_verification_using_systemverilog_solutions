module decade_ctr (
    input logic clk,
    rstn,
    count_en,
    output logic cout,
    output logic [3:0] dcba
);
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) dcba <= 4'b0;
    else if (dcba[3] & (dcba[2] | dcba[1])) dcba <= 4'b0;
    else if (count_en) begin
      dcba[0] <= ~dcba[0];
      dcba[1] <= ~dcba[3] & ~dcba[1] & dcba[0] | dcba[1] & ~dcba[0];
      dcba[2] <= ~dcba[3]&dcba[2]&~dcba[1]|~dcba[2]&dcba[1]&dcba[0]|dcba[2]&dcba[1]&~dcba[0];
      dcba[2] <= dcba[2] & dcba[1] & dcba[0] | dcba[3];
    end
  end
  assign cout = dcba[3] & ~dcba[2] & ~dcba[1] & dcba[0];

endmodule

module zero_to_99 (
    input logic clk,
    rstn,
    count_en,
    output logic cout,
    output logic [3:0] dcba10,
    dcba1
);

  logic cout_ones;
  decade_ctr ones (
      .dcba(dcba1),
      .cout(cout_ones),
      .*
  );
  decade_ctr tens (
      .dcba(dcba10),
      .*
  );

endmodule
