class amm_agent_rd #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local amm_driver_rd #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) drv;

  local amm_monitor_rd #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH )
  ) mon;

  function new(
    input virtual amm_rd_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH )
    ) rd_if,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram
  );
    this.drv = new( rd_if, ram );
    this.mon = new( rd_if );
  endfunction

  task run();
    fork
      this.drv.run();
      this.mon.run();
    join_none
  endtask

endclass
