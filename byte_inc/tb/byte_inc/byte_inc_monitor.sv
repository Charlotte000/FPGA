class byte_inc_monitor #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual byte_inc_if #( ADDR_WIDTH ) set_if;

  local mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) src2scb;

  local mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) snk2scb;

  local amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) ram;

  function new(
    input virtual byte_inc_if #( ADDR_WIDTH ) set_if,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) src2scb,
    input mailbox #( byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) ) snk2scb,
    input amm_ram #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) ram
  );
    this.set_if  = set_if;
    this.src2scb = src2scb;
    this.snk2scb = snk2scb;
    this.ram     = ram;
  endfunction

  local task check_unknown();
    forever
      begin
        @( this.set_if.mon_cb );

        // base_addr_i
        assert( ( this.set_if.mon_cb.run === 1'b1 ) -> ( !$isunknown( this.set_if.mon_cb.base_addr ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "base_addr_i" );

        // length_i
        assert( ( this.set_if.mon_cb.run === 1'b1 ) -> ( !$isunknown( this.set_if.mon_cb.length ) ) )
        else $display( "%8d ns: %25s is unknown", $time, "length_i" );

        // run_i
        assert( !$isunknown( this.set_if.mon_cb.run ) )
        else $display( "%8d ns: %25s is unknown", $time, "run_i" );

        // waitrequest_o
        assert( !$isunknown( this.set_if.mon_cb.waitrequest ) )
        else $display( "%8d ns: %25s is unknown", $time, "waitrequest_o" );
      end
  endtask

  local task check_strobe();
    logic [1:0] run = '{ 1'b0, 1'b0 };
    forever
      begin
        @( this.set_if.mon_cb );
        run = '{ run[0], this.set_if.mon_cb.run };

        assert( run != '{ 1'b1, 1'b1 } )
        else $display( "%8d ns: run_i must be a stobe", $time );
      end
  endtask

  local task check_logic();
    forever
      begin
        @( this.set_if.mon_cb );

        // run_i
        assert( ( this.set_if.mon_cb.waitrequest === 1'b1 ) -> ( this.set_if.mon_cb.run === 1'b0 ) )
        else $display( "%8d ns: run_i while waitrequest_o", $time );
      end
  endtask

  local task collect_data();
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) tr;
    forever
      begin
        @( posedge this.set_if.run );
        tr = new( this.set_if.base_addr, this.set_if.length, this.ram.copy() );
        this.src2scb.put( tr );

        @( negedge this.set_if.waitrequest );

        // Need to wait until last write operation completes before taking a snapshot ( TODO ? )
        @( this.set_if.mon_cb );
        @( this.set_if.mon_cb );
        @( this.set_if.mon_cb );

        tr = new( tr.base_addr, tr.length, this.ram.copy() ); // Keep old base_addr and length, just update ram snapshot
        this.snk2scb.put( tr );
      end
  endtask

  task run();
    fork
      this.check_unknown();
      this.check_strobe();
      this.check_logic();

      this.collect_data();
    join_none
  endtask

endclass
