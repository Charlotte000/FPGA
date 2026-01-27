import amm_package::*;

class amm_monitor_wr #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual amm_if #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) wr_if;

  function new(
    input virtual amm_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) wr_if
  );
    this.wr_if = wr_if;
  endfunction

  local task check_unknown();
    forever
      begin
        @( this.wr_if.mon_cb );

        // amm_wr_waitrequest_i
        assert( !$isunknown( this.wr_if.mon_cb.waitrequest ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_wr_waitrequest_i" );

        // amm_wr_write_o
        assert( !$isunknown( this.wr_if.mon_cb.write ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_wr_write_o" );

        // amm_wr_address_o
        assert( ( this.wr_if.mon_cb.write === 1'b1 ) -> ( !$isunknown( this.wr_if.mon_cb.address ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_wr_address_o" );

        // amm_wr_writedata_o
        assert( ( this.wr_if.mon_cb.write === 1'b1 ) -> ( !$isunknown( this.wr_if.mon_cb.data ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_wr_writedata_o" );

        // amm_wr_byteenable_o
        assert( ( this.wr_if.mon_cb.write === 1'b1 ) -> ( !$isunknown( this.wr_if.mon_cb.byteenable ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "amm_wr_byteenable_o" );
      end
  endtask

  task run();
    fork
      this.check_unknown();
    join_none
  endtask

endclass
