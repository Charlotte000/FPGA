import amm_package::*;

class amm_driver_rd #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual amm_if #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) rd_if;

  local amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) ram;

  function new(
    input virtual amm_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) rd_if,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram
  );
    this.rd_if = rd_if;
    this.ram   = ram;
  endfunction

  local function void reset();
    this.rd_if.rd_cb.data        <= 'x;
    this.rd_if.rd_cb.datavalid   <= 1'b0;
    this.rd_if.rd_cb.waitrequest <= 1'b0;
  endfunction

  local task rd_delay();
    this.rd_if.rd_cb.waitrequest <= 1'b1;
    repeat( get_rd_wait_count() )
      @( this.rd_if.rd_cb );
    this.rd_if.rd_cb.waitrequest <= 1'b0;
  endtask

  task run();
    forever
      begin
        this.reset();

        if( this.rd_if.rd_cb.read )
          begin
            logic [ADDR_WIDTH-1:0] addr = this.rd_if.rd_cb.address;

            this.rd_delay();

            // Read
            this.rd_if.rd_cb.data      <= this.ram.read( addr );
            this.rd_if.rd_cb.datavalid <= 1'b1;
          end

        @( this.rd_if.rd_cb );
      end
  endtask

endclass
