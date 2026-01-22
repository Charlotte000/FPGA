class byte_inc_environment #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local amm_ram #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) ram;

  local amm_agent_rd #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) amm_agent_rd;

  local amm_agent_wr #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) amm_agent_wr;

  local byte_inc_agent #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) byte_inc_agent;

  local byte_inc_generator #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) generator;

  local byte_inc_scoreboard #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .BYTE_CNT   ( BYTE_CNT   )
  ) scoreboard;

  local mailbox #(
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
  ) gen2drv = new(); // In gen2drv we dont care about ram_snapshot in transaction, so it null

  local mailbox #(
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
  ) src2scb = new();

  local mailbox #(
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
  ) snk2scb = new();

  function new(
    input virtual byte_inc_if #(
      .ADDR_WIDTH ( ADDR_WIDTH )
    ) set_if,
    input virtual amm_rd_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH )
    ) rd_if,
    input virtual amm_wr_if #(
      .DATA_WIDTH ( DATA_WIDTH ),
      .ADDR_WIDTH ( ADDR_WIDTH ),
      .BYTE_CNT   ( BYTE_CNT   )
    ) wr_if
  );
    this.ram            = new();

    this.amm_agent_rd   = new( rd_if, this.ram );
    this.amm_agent_wr   = new( wr_if, this.ram );
    this.byte_inc_agent = new( set_if, this.gen2drv, this.src2scb, this.snk2scb, this.ram );

    this.generator      = new( this.gen2drv );
    this.scoreboard     = new( this.src2scb, this.snk2scb );
  endfunction

  task run( input int unsigned timeout = 10_000_000 );
    amm_package::ram_speed = FAST; // RANDOM, SLOW, FAST
    this.ram.fill_data_random();   // .fill_data_random(), .fill_data_plain(), .fill_data_same( val )

    fork : run
      this.generator.send_different_lengths();
      // this.generator.send_overflow();
      // this.generator.send_random();

      this.amm_agent_rd.run();
      this.amm_agent_wr.run();
      this.byte_inc_agent.run();
      this.scoreboard.run();
    join_none

    // Wait for the first transaction
    #10_000;

    // Timeout
    repeat( timeout )
      begin
        if( ( this.gen2drv.num() == 0 ) && ( this.src2scb.num() == 0 ) && ( this.snk2scb.num() == 0 ) )
          break;

        #1;
      end

    disable run;

    // Check remaining transactions
    assert( this.gen2drv.num() == 0 )
    else $display( "Not all transactions were sent (%0d) (you might want to increase timeout)", this.gen2drv.num() );

    assert( ( this.src2scb.num() == 0 ) && ( this.snk2scb.num() == 0 ) )
    else $display( "Not all transactions were checked (%0d/%0d)", this.src2scb.num(), this.snk2scb.num() );
  endtask
endclass
