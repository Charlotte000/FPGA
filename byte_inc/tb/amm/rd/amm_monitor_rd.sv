import amm_package::*;

class amm_monitor_rd #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual amm_if #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) rd_if;

  function new(
    input virtual amm_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) rd_if
  );
    this.rd_if = rd_if;
  endfunction

  local task check_unknown();
    forever
      begin
        @( this.rd_if.mon_cb );

        // amm_rd_readdatavalid_i
        assert( !$isunknown( this.rd_if.mon_cb.readdatavalid ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_rd_readdatavalid_i" );

        // amm_rd_waitrequest_i
        assert( !$isunknown( this.rd_if.mon_cb.waitrequest ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_rd_waitrequest_i" );

        // amm_rd_readdata_i
        assert( ( this.rd_if.mon_cb.readdatavalid === 1'b1 ) -> ( !$isunknown( this.rd_if.mon_cb.readdata ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_rd_readdata_i" );

        // amm_rd_read_o
        assert( !$isunknown( this.rd_if.mon_cb.read ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_rd_read_o" );

        // amm_rd_address_o
        assert( ( this.rd_if.mon_cb.read === 1'b1 ) -> ( !$isunknown( this.rd_if.mon_cb.address ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_rd_address_o" );
      end
  endtask

  task run();
    fork
      this.check_unknown();
    join_none
  endtask

endclass
