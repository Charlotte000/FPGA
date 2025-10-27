module mux_tb;

logic [1:0] data0_i;
logic [1:0] data1_i;
logic [1:0] data2_i;
logic [1:0] data3_i;

logic [1:0] direction_i;

logic [1:0] data_o;

initial
  begin
    data0_i <= 2'b11;
    data1_i <= 2'b10;
    data2_i <= 2'b01;
    data3_i <= 2'b00;
  end

mux DUT (
  .data0_1     ( data0_i[1]     ),
  .data0_0     ( data0_i[0]     ),
  .data1_0     ( data1_i[0]     ),
  .data1_1     ( data1_i[1]     ),
  .data2_0     ( data2_i[0]     ),
  .data2_1     ( data2_i[1]     ),
  .data3_0     ( data3_i[0]     ),
  .data3_1     ( data3_i[1]     ),
  .direction_0 ( direction_i[0] ),
  .direction_1 ( direction_i[1] ),
  .data_o_0    ( data_o[0]    ),
  .data_o_1    ( data_o[1]    )
);

initial
  begin
    $monitor( data_o );

    direction_i <= 2'b00;
    #10;
    direction_i <= 2'b01;
    #10;
    direction_i <= 2'b10;
    #10;
    direction_i <= 2'b11;
    #10;
  end

endmodule
