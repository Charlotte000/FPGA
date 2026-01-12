`include "lifo_generator.sv"
`include "lifo_monitor.sv"

`timescale 1ns/1ns
module lifo_tb #(
  parameter int unsigned DWIDTH             = 16,
  parameter int unsigned AWIDTH             = 8,
  parameter int unsigned ALMOST_FULL_VALUE  = 2,
  parameter int unsigned ALMOST_EMPTY_VALUE = 2,

  parameter time         PERIOD             = 10ns
);

bit clk;
bit srst;

lifo_if #(
  .DWIDTH ( DWIDTH ),
  .AWIDTH ( AWIDTH )
) lifo_if (
  .clk  ( clk  ),
  .srst ( srst )
);

lifo #(
  .DWIDTH       ( DWIDTH             ),
  .AWIDTH       ( AWIDTH             ),
  .ALMOST_FULL  ( ALMOST_FULL_VALUE  ),
  .ALMOST_EMPTY ( ALMOST_EMPTY_VALUE )
) DUT (
  .clk_i          ( lifo_if.clk          ),
  .srst_i         ( lifo_if.srst         ),
  .wrreq_i        ( lifo_if.wrreq        ),
  .data_i         ( lifo_if.data         ),
  .rdreq_i        ( lifo_if.rdreq        ),
  .q_o            ( lifo_if.q            ),
  .almost_empty_o ( lifo_if.almost_empty ),
  .empty_o        ( lifo_if.empty        ),
  .almost_full_o  ( lifo_if.almost_full  ),
  .full_o         ( lifo_if.full         ),
  .usedw_o        ( lifo_if.usedw        )
);

lifo_generator #(
      .DWIDTH ( DWIDTH ),
      .AWIDTH ( AWIDTH )
) generator = new( lifo_if );

lifo_monitor #(
  .DWIDTH             ( DWIDTH             ),
  .AWIDTH             ( AWIDTH             ),
  .ALMOST_FULL_VALUE  ( ALMOST_FULL_VALUE  ),
  .ALMOST_EMPTY_VALUE ( ALMOST_EMPTY_VALUE )
) monitor = new( lifo_if );

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
  monitor.reset();
  @( posedge clk );
endtask

task automatic clock();
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );
endtask

// == Tests ==
task automatic test_full_write();
  $display( "Begin test: Full write" );
  fork
    generator.send_fill( 2 ** AWIDTH );
    monitor.listen( ( 2 ** AWIDTH ) + 100 );
  join
  $display( "End test:   Full write" );
  reset();
endtask

task automatic test_full_read();
  $display( "Begin test: Full read" );
  fork
    begin
      generator.send_fill( 2 ** AWIDTH ); // Fill first
      generator.send_read( 2 ** AWIDTH ); // Then read
    end
    monitor.listen( ( 2 ** AWIDTH ) * 2 + 100 );
  join
  $display( "End test:   Full read" );
  reset();
endtask

task automatic test_read_write();
  $display( "Begin test: Read/write" );
  fork
    begin
      generator.send_random( 1, 100, 100 );       // Empty rw

      generator.send_fill( ( 2 ** AWIDTH ) / 2 );
      generator.send_random( 1, 100, 100 );       // Half full rw

      generator.send_fill( ( 2 ** AWIDTH ) / 2 );
      generator.send_random( 1, 100, 100 );       // Full rw
    end
    monitor.listen( ( 2 ** AWIDTH ) + 100 );
  join
  $display( "End test:   Read/write" );
  reset();
endtask

task automatic test_overflow_write();
  $display( "Begin test: Overflow write" );
  fork
    generator.send_fill( ( 2 ** AWIDTH ) * 2 );
    monitor.listen( ( 2 ** AWIDTH ) * 2 + 100 );
  join
  $display( "End test:   Overflow write" );
  reset();
endtask

task automatic test_read_from_empty();
  $display( "Begin test: Read from empty" );
  fork
    begin
      generator.send_fill( ( 2 ** AWIDTH ) / 2 ); // Fill in half
      generator.send_read( ( 2 ** AWIDTH ) * 2 ); // Read more than there is
    end
    monitor.listen( ( 2 ** AWIDTH ) * 3 + 100 );
  join
  $display( "End test:   Read from empty" );
  reset();
endtask

task automatic test_random();
  $display( "Begin test: Random" );
  fork
    begin
      generator.send_random( 1000, 25, 75 );
      generator.send_random( 1000, 50, 50 );
      generator.send_random( 1000, 75, 50 );
    end
    monitor.listen( 3000 );
  join
  $display( "End test:   Random" );
  reset();
endtask
// == Tests ==

initial
  begin
    fork
      clock();
    join_none

    reset();

    // == Test calls ==
    test_full_write();
    test_full_read();
    test_read_write();
    test_overflow_write();
    test_read_from_empty();
    test_random();
    // == Test calls ==

    $stop;
  end

endmodule
