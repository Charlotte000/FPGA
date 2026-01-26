class amm_agent_wr #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local amm_driver_wr #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) drv;

  local amm_monitor_wr #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) mon;

  function new(
    input virtual amm_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) wr_if,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram
  );
    this.drv = new( wr_if, ram );
    this.mon = new( wr_if );
  endfunction

  task run();
    fork
      this.drv.run();
      this.mon.run();
    join_none
  endtask

endclass
