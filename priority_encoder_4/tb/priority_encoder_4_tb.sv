module priority_encoder_4_tb;

logic [3:0] data_i;
logic       data_val_i;

logic [3:0] data_left_o;
logic [3:0] data_right_o;
logic       data_val_o;

task automatic test_case(
    input logic [3:0] data,
    input logic       data_val
  );
  logic [3:0] data_left_true;
  logic [3:0] data_right_true;
  logic       data_val_true;

  data_i     = data;
  data_val_i = data_val;

  // Calculate true data_left
  data_left_true = 'b0;
  for( int i = 3; i >= 0; i-- )
    begin
      if( data_i[i] === 1'b1 )
        begin
          data_left_true = 1 << i;
          break;
        end
    end

  // Calculate true data_right
  data_right_true = 'b0;
  for( int i = 0; i < 4; i++ )
    begin
      if( data_i[i] === 1'b1 )
        begin
          data_right_true = ( 1 << i );
          break;
        end
    end

  // Calculate true data_val
  data_val_true = data_val;

  #10

  if(
    ( data_val_o !== data_val_true ) ||
    ( data_val_o === 1'b1 ) && ( ( data_left_o !== data_left_true ) || ( data_right_o !== data_right_true ) )
  )
    begin
      $display(
        "Test Failed: ( data_i = %b, data_val = %b ), expected %b, %b, %b but got %b, %b, %b",
        data_i,
        data_val_i,
        data_left_true,
        data_right_true,
        data_val_true,
        data_left_o,
        data_right_o,
        data_val_o
      );
      $stop;
    end
endtask

priority_encoder_4 DUT (
  .data_0_i       ( data_i[0]       ),
  .data_1_i       ( data_i[1]       ),
  .data_2_i       ( data_i[2]       ),
  .data_3_i       ( data_i[3]       ),
  .data_val_i     ( data_val_i      ),
  .data_left_0_o  ( data_left_o[0]  ),
  .data_left_1_o  ( data_left_o[1]  ),
  .data_left_2_o  ( data_left_o[2]  ),
  .data_left_3_o  ( data_left_o[3]  ),
  .data_right_0_o ( data_right_o[0] ),
  .data_right_1_o ( data_right_o[1] ),
  .data_right_2_o ( data_right_o[2] ),
  .data_right_3_o ( data_right_o[3] ),
  .data_val_o     ( data_val_o      )
);

initial
  begin
    data_val_i = 1'b0;

    for( int i = 0; i < 100; i++ )
      test_case( $urandom_range( 15, 0 ), $urandom_range( 1, 0 ) );

    $display( "Tests Passed" );
  end

endmodule
