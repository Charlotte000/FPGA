class byte_inc_generator #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  localparam int unsigned ADDR_MAX = ( ( 2 ** ADDR_WIDTH ) - 1 );

  local mailbox #(
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
  ) gen2drv;

  function new(
    input mailbox #(
      byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT )
    ) gen2drv
  );
    this.gen2drv = gen2drv;
  endfunction

  task send_random( input int unsigned count = 100 );
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) tr;

    repeat( count )
      begin
        tr = new( $urandom_range( 0, ADDR_MAX ), $urandom_range( 0, ADDR_MAX ) );
        this.gen2drv.put( tr );
      end
  endtask

  task send_overflow();
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) tr;
    tr = new( ( ADDR_MAX - 1 ), ( BYTE_CNT * 3 ) );
    this.gen2drv.put( tr );
  endtask

  task send_different_lengths();
    byte_inc_transaction #( DATA_WIDTH, ADDR_WIDTH, BYTE_CNT ) tr;

    for( int length = ADDR_MAX; length >= ADDR_MAX - 4; length-- )
      begin
        tr = new( 0, length );
        this.gen2drv.put( tr );
      end

    for( int length = 4; length >= 0; length-- )
      begin
        tr = new( 0, length );
        this.gen2drv.put( tr );
      end
  endtask

endclass
