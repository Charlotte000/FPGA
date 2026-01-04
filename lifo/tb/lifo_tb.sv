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

task automatic reset();
  srst <= 1'b1;
  @( posedge clk );
  srst <= 1'b0;
  @( posedge clk );
endtask

task automatic clock();
  forever
    #( PERIOD / 2.0 ) clk <= ( !clk );
endtask

initial
  begin
    automatic lifo_generator #(
      .DWIDTH ( DWIDTH ),
      .AWIDTH ( AWIDTH )
    ) generator = new( lifo_if );

    automatic lifo_monitor #(
      .DWIDTH             ( DWIDTH             ),
      .AWIDTH             ( AWIDTH             ),
      .ALMOST_FULL_VALUE  ( ALMOST_FULL_VALUE  ),
      .ALMOST_EMPTY_VALUE ( ALMOST_EMPTY_VALUE )
    ) monitor = new( lifo_if );

    fork
      clock();
    join_none

    reset();

    fork
      generator.run();
      monitor.run();
    join_any

    $stop;
  end

endmodule
