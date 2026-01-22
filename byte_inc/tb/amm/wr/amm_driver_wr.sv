import amm_package::*;

class amm_driver_wr #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual amm_wr_if #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) wr_if;

  local amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) ram;

  function new(
    input virtual amm_wr_if #(
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
    this.wr_if = wr_if;
    this.ram   = ram;
  endfunction

  local task wr_delay();
    this.wr_if.cb.waitrequest <= 1'b1;
    repeat( get_wr_wait_count() )
      @( this.wr_if.cb );
    this.wr_if.cb.waitrequest <= 1'b0;
  endtask

  task run();
    forever
      begin
        this.wr_if.cb.waitrequest <= 1'b0;

        if( this.wr_if.cb.write )
          begin
            logic [ADDR_WIDTH-1:0] addr       = this.wr_if.cb.address;
            logic [DATA_WIDTH-1:0] data       = this.wr_if.cb.writedata;
            logic [BYTE_CNT-1:0]   byteenable = this.wr_if.cb.byteenable;

            this.wr_delay();

            // Write
            this.ram.write( addr, data, byteenable );
          end

        @( this.wr_if.cb );
      end
  endtask

endclass
