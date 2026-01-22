class byte_inc_agent #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local byte_inc_driver #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) drv;

  local byte_inc_monitor #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) mon;

  function new(
    input virtual byte_inc_if #( ADDR_WIDTH ) set_if,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) gen2drv,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) src2scb,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) snk2scb,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram
  );
    this.drv = new( set_if, gen2drv );
    this.mon = new( set_if, src2scb, snk2scb, ram );
  endfunction

  task run();
    fork
      this.drv.run();
      this.mon.run();
    join_none
  endtask

endclass
