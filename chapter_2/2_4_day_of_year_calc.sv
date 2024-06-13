

// i spent too much time on this problem so i didnt fish it
module day_of_yr_calc (
    input  logic [ 5:0] day_of_month,
    input  logic [ 3:0] month,
    input  logic [10:0] year,
    output logic [ 8:0] day_of_yr
);
  logic [8:0] from_month;
  logic leap;
  always_comb begin
    case (month)
      3'b10:   from_month = 9'd31;
      3'b11:   from_month = 9'd59;
      3'b100:  from_month = 9'd90;
      3'b101:  from_month = 9'd120;
      3'b110:  from_month = 9'd151;
      3'b111:  from_month = 9'd181;
      3'b1000: from_month = 9'd212;
      3'b1001: from_month = 9'd243;
      3'b1010: from_month = 9'd273;
      3'b1011: from_month = 9'd304;
      3'b1100: from_month = 9'd334;
      default: from_month = 9'b0;
    endcase
    from_month = from_month + day_of_month;
    leap = ~(year[1] | year[0]);  // i still need to check if a number is divisible by 100
    day_of_yr = leap ? (from_month + 1'b1) : from_month;
  end

endmodule

`timescale 1ns / 1ps

module tb_day_of_yr_calc;
  logic [ 5:0] day_of_month;
  logic [ 3:0] month;
  logic [10:0] year;

  logic [ 8:0] day_of_yr;

  day_of_yr_calc dut (.*);

  initial begin
    day_of_month = 6'b0;
    year = 10'd1992;
    month = 4'b1;
    for (year = 10'd1992; year <= 10'd2024; year++) begin
      for (month = 4'b1; month <= 4'b1100; month++) begin
        for (day_of_month = 6'b0; day_of_month <= 6'd28; day_of_month = day_of_month + 4) begin
          #2ns;
          if (software_calc(day_of_month, month, year) != day_of_yr)
            $display(
                "ERROR: day_of_month = %d, month = %d year = %d, software_calc = %d (day_of_yr = %d) ",
                day_of_month,
                month,
                year,
                software_calc,
                day_of_yr
            );

        end
      end
    end


  end

  function logic [8:0] software_calc(input logic [5:0] day_of_month, input logic [3:0] month,
                                     input logic [10:0] year);
    int n1, n2, n3;
    n1 = $floor(275 * month / 9);  // Approximates cumulative days to the start of the given month.
    n2 = $floor((month + 9) /
                12);  //Determines if the month is after February for leap year adjustment.
    n3 = (1 + $floor((year - 4 * $floor(year / 4) + 2) / 3));  //Checks if the year is a leap year.
    software_calc = n1 - (n2 * n3) + day_of_month - 30; //Computes the final day of the year considering all adjustments.
  endfunction




endmodule
