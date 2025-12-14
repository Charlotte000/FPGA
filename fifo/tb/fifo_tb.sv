`timescale 1ns/1ns
module fifo_tb #(
  parameter int unsigned DWIDTH             = 8,
  parameter int unsigned AWIDTH             = 4,
  parameter int unsigned ALMOST_FULL_VALUE  = 12,
  parameter int unsigned ALMOST_EMPTY_VALUE = 4,

  parameter time         PERIOD             = 10ns
);

bit                clk;
bit                srst;

logic [DWIDTH-1:0] data;

logic              wrreq;
logic              rdreq;

logic [DWIDTH-1:0] q_dut;
logic [AWIDTH:0]   usedw_dut;
logic              empty_dut;
logic              full_dut;
logic              almost_full_dut;
logic              almost_empty_dut;

logic [DWIDTH-1:0] q_golden;
logic [AWIDTH-1:0] usedw_golden;
logic              empty_golden;
logic              full_golden;
logic              almost_full_golden;
logic              almost_empty_golden;

fifo #(
  .DWIDTH             ( DWIDTH             ),
  .AWIDTH             ( AWIDTH             ),
  .ALMOST_FULL_VALUE  ( ALMOST_FULL_VALUE  ),
  .ALMOST_EMPTY_VALUE ( ALMOST_EMPTY_VALUE )
) DUT (
  .clk_i          ( clk              ),
  .srst_i         ( srst             ),
  .data_i         ( data             ),
  .wrreq_i        ( wrreq            ),
  .rdreq_i        ( rdreq            ),
  .q_o            ( q_dut            ),
  .usedw_o        ( usedw_dut        ),
  .empty_o        ( empty_dut        ),
  .full_o         ( full_dut         ),
  .almost_full_o  ( almost_full_dut  ),
  .almost_empty_o ( almost_empty_dut )
);

scfifo #(
  .lpm_width               ( DWIDTH                ),
  .lpm_widthu              ( AWIDTH                ),
  .lpm_numwords            ( 2 ** AWIDTH           ),
  .lpm_showahead           ( "ON"                  ),
  .lpm_type                ( "scfifo"              ),
  .lpm_hint                ( "RAM_BLOCK_TYPE=M10K" ),
  .intended_device_family  ( "Cyclone V"           ),
  .underflow_checking      ( "ON"                  ),
  .overflow_checking       ( "ON"                  ),
  .allow_rwcycle_when_full ( "OFF"                 ),
  .use_eab                 ( "ON"                  ),
  .add_ram_output_register ( "OFF"                 ),
  .almost_full_value       ( ALMOST_FULL_VALUE     ),
  .almost_empty_value      ( ALMOST_EMPTY_VALUE    ),
  .maximum_depth           ( 0                     ),
  .enable_ecc              ( "FALSE"               )
) golden_model (
  .clock        ( clk                 ),
  .sclr         ( srst                ),
  .data         ( data                ),
  .wrreq        ( wrreq               ),
  .rdreq        ( rdreq               ),
  .empty        ( empty_golden        ),
  .full         ( full_golden         ),
  .usedw        ( usedw_golden        ),
  .almost_full  ( almost_full_golden  ),
  .almost_empty ( almost_empty_golden ),
  .q            ( q_golden            ),
  .aclr         (                     ),
  .eccstatus    (                     )
);

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
endtask

task automatic clock();
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );
endtask

task automatic send(
  input int unsigned count,
  input int unsigned write_chance,
  input int unsigned read_chance
);
  repeat( count )
    begin
      wrreq <= 1'b0;
      rdreq <= 1'b0;
      data  <= 'x;

      if( $urandom_range(1, 100) <= write_chance )
        begin
          wrreq <= 1'b1;
          data  <= $urandom_range(0, ( ( 2 ** DWIDTH ) - 1 ) );
        end

      if( $urandom_range(1, 100) <= read_chance )
        rdreq <= 1'b1;

      @( posedge clk );
    end
endtask

task automatic listen();
  forever
    begin
      @( posedge clk );

      assert( almost_full_dut === almost_full_golden )
      else
        begin
          $error( "Test Failed: %s != %s ( %0d != %0d )", "almost_full_dut", "almost_full_golden", almost_full_dut, almost_full_golden );
          $stop;
        end

      assert( almost_empty_dut === almost_empty_golden )
      else
        begin
          $error( "Test Failed: %s != %s ( %0d != %0d )", "almost_empty_dut", "almost_empty_golden", almost_empty_dut, almost_empty_golden );
          $stop;
        end

      assert( full_dut === full_golden )
      else
        begin
          $error( "Test Failed: %s != %s ( %0d != %0d )", "full_dut", "full_golden", full_dut, full_golden );
          $stop;
        end

      assert( empty_dut === empty_golden )
      else
        begin
          $error( "Test Failed: %s != %s ( %0d != %0d )", "empty_dut", "empty_golden", empty_dut, empty_golden );
          $stop;
        end

      assert( usedw_dut[AWIDTH-1:0] === usedw_golden )
      else
        begin
          $error( "Test Failed: %s != %s ( %0d != %0d )", "usedw_dut", "usedw_golden", usedw_dut, usedw_golden );
          $stop;
        end

      // assert( q_dut === q_golden )
      // else
      //   begin
      //     $error( "Test Failed: %s != %s ( %0d != %0d )", "q_dut", "q_golden", q_dut, q_golden );
      //     $stop;
      //   end
    end
endtask

initial
  begin
    wrreq <= 1'b0;
    rdreq <= 1'b0;

    fork
      clock();
    join_none

    reset();

    fork
      begin
        send( 1000,   0, 100 );
        send( 1000, 100,   0 );
        send( 1000,  50,  50 );
      end

      listen();
    join_any

    $display( "Tests Passed" );
    $stop;
  end

endmodule
