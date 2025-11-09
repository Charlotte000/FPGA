module delay_15_tb;

bit         clk;
bit         rst;

logic       data_i;
logic [3:0] data_delay_i;

logic       data_o;

delay_15 DUT (
  .clk_i        ( clk          ),
  .rst_i        ( rst          ),
  .data_i       ( data_i       ),
  .data_delay_i ( data_delay_i ),
  .data_o       ( data_o       )
);

task reset();
  rst = 1;
  ##1;
  rst = 0;
  ##0;
endtask

task test_case( input logic [3:0] data_delay );
  reset();

  data_delay_i = data_delay;

  for( int i = 0; i < data_delay; i++ )
    begin
      data_i = i == 0;
      ##1;
    end

  ##1;
  if( data_o !== 1 )
    begin
      $display( "Test Failed: ( data_delay_i = %b ) expected %b but got %b", data_delay_i, 1'b1, data_o );
      $stop;
    end
endtask

initial
  forever
    #10 clk = !clk;

default clocking cb @ ( posedge clk );
endclocking

initial
  begin
    reset();
    data_delay_i = 4'b0001;

    for( int i = 0; i < 100; i++ )
      test_case( $urandom_range(15, 1) );

    $display( "Tests Passed" );
    $stop;
  end

endmodule
