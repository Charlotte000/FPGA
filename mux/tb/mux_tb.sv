module mux_tb;

logic [1:0] data0_i;
logic [1:0] data1_i;
logic [1:0] data2_i;
logic [1:0] data3_i;

logic [1:0] direction_i;

logic [1:0] data_o;

mux DUT (
  .direction_0_i ( direction_i[0] ),
  .direction_1_i ( direction_i[1] ),
  .data0_0_i     ( data0_i[0]     ),
  .data0_1_i     ( data0_i[1]     ),
  .data1_0_i     ( data1_i[0]     ),
  .data1_1_i     ( data1_i[1]     ),
  .data2_0_i     ( data2_i[0]     ),
  .data2_1_i     ( data2_i[1]     ),
  .data3_0_i     ( data3_i[0]     ),
  .data3_1_i     ( data3_i[1]     ),
  .data_0_o      ( data_o[0]      ),
  .data_1_o      ( data_o[1]      )
);

initial
  begin
    data0_i <= 2'b11;
    data1_i <= 2'b10;
    data2_i <= 2'b01;
    data3_i <= 2'b00;

    direction_i <= 2'b00;
    #10;
    if( data_o != 2'b11 )
      begin
        $display( "Test Failed: expected %b but got %b", 2'b11, data_o );
        $stop;
      end

    direction_i <= 2'b01;
    #10;
    if( data_o != 2'b10 )
      begin
        $display( "Test Failed: expected %b but got %b", 2'b10, data_o );
        $stop;
      end

    direction_i <= 2'b10;
    #10;
    if( data_o != 2'b01 )
      begin
        $display( "Test Failed: expected %b but got %b", 2'b01, data_o );
        $stop;
      end

    direction_i <= 2'b11;
    #10;
    if( data_o != 2'b00 )
      begin
        $display( "Test Failed: expected %b but got %b", 2'b00, data_o );
        $stop;
      end

    $display( "Tests Passed" );
  end

endmodule
