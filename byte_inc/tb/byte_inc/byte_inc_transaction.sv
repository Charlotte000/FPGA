import amm_package::*;

class byte_inc_transaction #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) ram_snapshot;

  logic [ADDR_WIDTH-1:0] base_addr;

  logic [ADDR_WIDTH-1:0] length;

  function new(
    input logic [ADDR_WIDTH-1:0] base_addr,
    input logic [ADDR_WIDTH-1:0] length,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram_snapshot = null
  );
    this.base_addr    = base_addr;
    this.length       = length;
    this.ram_snapshot = ram_snapshot;
  endfunction

  function byte_inc_transaction #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) copy();
    byte_inc_transaction #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) c = new(
      this.base_addr,
      this.length,
      ( this.ram_snapshot ) ? ( this.ram_snapshot.copy() ) : ( null ) // remember ram_snapshot is null in gen2drv
    );
    return c;
  endfunction

endclass
