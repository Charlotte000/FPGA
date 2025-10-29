module mux_tb;

logic [1:0] data0_i;
logic [1:0] data1_i;
logic [1:0] data2_i;
logic [1:0] data3_i;

logic [1:0] direction_i;

logic [1:0] data_o;

task test_case(
    input  logic [1:0] data,
    input  logic [1:0] direction
  );
  case( direction )
    2'b00:   data0_i = data;
    2'b01:   data1_i = data;
    2'b10:   data2_i = data;
    2'b11:   data3_i = data;
    default: data0_i = data;
  endcase
  direction_i = direction;

  #10

  if( data_o !== data )
  begin
    $display( "Test Failed: expected %b but got %b", data, data_o );
    $stop;
  end
endtask

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
    for( int i = 0; i < 100; i++ )
      test_case( $urandom_range(3, 0), $urandom_range(3, 0) );

    $display( "Tests Passed" );
  end

endmodule
