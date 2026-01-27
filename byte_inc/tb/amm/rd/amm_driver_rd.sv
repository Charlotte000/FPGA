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
    this.rd_if.rd_cb.data      <= 'x;
    this.rd_if.rd_cb.datavalid <= 1'b0;
  endfunction

  local task set_waitrequest();
    forever
      begin
        this.rd_if.rd_cb.waitrequest <= ( $urandom_range( 1, 100 ) <= RD_WAITREQUEST_CHANCE );
        @( this.rd_if.rd_cb );
      end
  endtask

  local task set_read();
    typedef struct {
      int unsigned                  timestamp;
      logic        [DATA_WIDTH-1:0] data;
    } read_task;
    read_task read_queue [$];

    for( int unsigned timestamp = 0; 1; timestamp++ )
      begin
        this.reset();

        // Push read tasks
        if( this.rd_if.rd_cb.read && ( !this.rd_if.waitrequest ) )
          begin
            read_task rt = '{
              timestamp: ( timestamp + get_rd_wait_count() ),
              data:      this.ram.read( this.rd_if.rd_cb.address )
            };
            read_queue.push_back( rt );
          end

        // Pop read tasks
        if( ( read_queue.size() > 0 ) && ( read_queue[0].timestamp <= timestamp ) )
          begin
            this.rd_if.rd_cb.data      <= read_queue.pop_front().data;
            this.rd_if.rd_cb.datavalid <= 1'b1;
          end

        @( this.rd_if.rd_cb );
      end
  endtask

  task run();
    fork
      this.set_waitrequest();
      this.set_read();
    join_none
  endtask

endclass
