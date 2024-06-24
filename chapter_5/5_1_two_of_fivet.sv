
module two_of_five (
    input  logic in,
    clk,
    rstn,
    output logic valid
);
 
  
  logic [2:0] nibble_counter, ones_count;
  logic istwo, isfour;



  //input counter
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) nibble_counter <= 3'b0;
    else if (isfour) nibble_counter <= 3'b0;
    else nibble_counter <= nibble_counter + 3'b1;
  end

  // ones counter
  always_ff @(posedge clk, negedge rstn) begin
    if (~rstn) ones_count <= 3'b0;
    else if (isfour) ones_count <= {2'b0,in};
    else ones_count <= ones_count + in;
  end

  assign isfour = nibble_counter == 3'b100;
  assign  istwo = ones_count == 3'b10;
  assign valid = isfour & istwo;


endmodule

`timescale 1ps / 1ps
module tb_two_of_five;
  logic in, clk, rstn, valid;

  logic [9:0] ser_in;
  logic [4:0] last5;

  two_of_five mut (.*);

  initial begin
    clk = 0;
    rstn = 0;
    in =0;
    ser_in = 10'b01110_00101;
   // last5 = 5'bx;
    #1 rstn = 1;
  end

  always #5 clk = ~clk;


  initial begin
  //  $monitor($time, " in = %b valid = %b", in, valid);
    for (int i = 0; i < 10; ++i) begin
      @(posedge clk);
      in <= ser_in[i];
     // last5 = i>4? ser_in[9:5]:ser_in[4:0];
      #3 $display($time, " in = %b valid = %b", in, valid);

    end
   // #225 $finish;

  end

endmodule
