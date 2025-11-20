`timescale 1ns/1ns

module serializer_tb #(
  parameter PERIOD        = 10,
  parameter DATA_W        = 16,
  parameter MOD_W         = $clog2(DATA_W),
  parameter MOD_IGNORE_LO = 1,
  parameter MOD_IGNORE_HI = 2
);

bit                clk;
bit                srst;

logic [DATA_W-1:0] data_i;
logic [MOD_W-1:0]  data_mod_i;
logic              data_val_i;

logic              ser_data_o;
logic              ser_data_val_o;

logic              busy_o;

serializer #(
  .DATA_W        ( DATA_W        ),
  .MOD_W         ( MOD_W         ),
  .MOD_IGNORE_LO ( MOD_IGNORE_LO ),
  .MOD_IGNORE_HI ( MOD_IGNORE_HI )
) DUT (
  .clk_i          ( clk            ),
  .srst_i         ( srst           ),
  .data_i         ( data_i         ),
  .data_mod_i     ( data_mod_i     ),
  .data_val_i     ( data_val_i     ),
  .ser_data_o     ( ser_data_o     ),
  .ser_data_val_o ( ser_data_val_o ),
  .busy_o         ( busy_o         )
);

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

task automatic test_case( input logic [DATA_W-1:0] data, input logic [MOD_W-1:0] mod );
  data_i     <= data;
  data_mod_i <= mod;
  data_val_i <= 1;
  @( posedge clk );

  data_val_i <= 0;

  if( !( ( MOD_IGNORE_LO <= mod ) && ( mod <= MOD_IGNORE_HI ) ) )
    begin
      for( int i = DATA_W - 1; i >= ( ( mod === 0 ) ? ( int'( 0 ) ) : int'( DATA_W - mod ) ); i-- )
        begin
          @( posedge clk );
          check( "ser_data_val_o", ser_data_val_o, 1,       $sformatf( "( data_i = %b, data_mod_i = %d, i = %0d )", data, mod, i ) );
          check( "busy_o",         busy_o,         1,       $sformatf( "( data_i = %b, data_mod_i = %d, i = %0d )", data, mod, i ) );
          check( "ser_data_o",     ser_data_o,     data[i], $sformatf( "( data_i = %b, data_mod_i = %d, i = %0d )", data, mod, i ) );
        end
    end

  @( posedge clk );
  check( "ser_data_val_o", ser_data_val_o, 0, $sformatf( "( data_i = %b, data_mod_i = %d )", data, mod ) );
  check( "busy_o",         busy_o,         0, $sformatf( "( data_i = %b, data_mod_i = %d )", data, mod ) );
endtask

task automatic reset();
  srst <= 1;
  @( posedge clk );
  srst <= 0;
  @( posedge clk );
endtask

initial
  forever
    #( PERIOD / 2 ) clk = !clk;

initial
  begin
    data_mod_i = 0;
    data_val_i = 0;
    reset();

    for( int mod = 0; mod < 2 ** MOD_W; mod++ )
      test_case( 16'hAAAA, mod );

    for( int i = 0; i < 100; i++ )
      test_case( $urandom_range( 2 ** DATA_W - 1, 0), $urandom_range( 2 ** MOD_W - 1, 0 ) );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
