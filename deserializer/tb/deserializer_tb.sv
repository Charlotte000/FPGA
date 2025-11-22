`timescale 1ns/1ns

module deserializer_tb #(
  parameter PERIOD = 10,
  parameter DATA_W = 16
);

bit                clk;
bit                srst;

logic              data_i;
logic              data_val_i;

logic [DATA_W-1:0] deser_data_o;
logic              deser_data_val_o;

deserializer #(
  .DATA_W ( DATA_W )
) DUT (
  .clk_i            ( clk              ),
  .srst_i           ( srst             ),
  .data_i           ( data_i           ),
  .data_val_i       ( data_val_i       ),
  .deser_data_o     ( deser_data_o     ),
  .deser_data_val_o ( deser_data_val_o )
);

task automatic reset();
  srst <= 1;
  @( posedge clk );
  srst <= 0;
  // @( posedge clk );
endtask

task automatic check(
  input string name,
  input int    val_pred,
  input int    val_true,
  input string additional_info = ""
);
  if( val_pred != val_true )
    begin
      $display( "Test Failed: %s expected %s = %0d but got %0d", additional_info, name, val_true, val_pred );
      $stop;
    end
endtask

task automatic test_case( input logic [DATA_W-1:0] data );
  for( int i = DATA_W - 1; i >= 0; i-- )
    begin
      data_i     <= data[i];
      data_val_i <= 1;
      @( posedge clk );
      check( "deser_data_val_o", deser_data_val_o, 0, $sformatf( "( data = %b, i = %0d )", data, i ) );
    end

  data_val_i <= 0;
  @( posedge clk );

  check( "deser_data_val_o", deser_data_val_o, 1,    $sformatf( "( data = %b )", data ) );
  check( "deser_data_o",     deser_data_o,     data                                     );
endtask

initial
  forever
    #( PERIOD / 2 ) clk = !clk;
initial
  begin
    data_val_i = 0;
    reset();

    repeat( 100 )
      test_case( $urandom_range( 2 ** DATA_W - 1, 0) );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
