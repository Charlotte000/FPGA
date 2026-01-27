import amm_package::*;

class amm_driver_wr #(
  parameter int unsigned DATA_WIDTH,
  parameter int unsigned ADDR_WIDTH,
  parameter int unsigned BYTE_CNT
);
  local virtual amm_if #(
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
    input virtual amm_if #(
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

  local task set_waitrequest();
    forever
      begin
        this.wr_if.wr_cb.waitrequest <= ( $urandom_range( 1, 100 ) <= WR_WAITREQUEST_CHANCE );
        @( this.wr_if.wr_cb );
      end
  endtask

  local task set_write();
    typedef struct {
      int unsigned                  timestamp;
      logic        [DATA_WIDTH-1:0] data;
      logic        [ADDR_WIDTH-1:0] address;
      logic        [BYTE_CNT-1:0]   byteenable;
    } write_task;
    write_task write_queue [$];

    for( int unsigned timestamp = 0; 1; timestamp++ )
      begin
        // Push write tasks
        if( this.wr_if.wr_cb.write && ( !this.wr_if.waitrequest ) )
          begin
            write_task wt = '{
              timestamp:  ( timestamp + WR_WAIT ),
              data:       this.wr_if.wr_cb.data,
              address:    this.wr_if.wr_cb.address,
              byteenable: this.wr_if.wr_cb.byteenable
            };
            write_queue.push_back( wt );
          end
        
        // Pop write tasks
        if( ( write_queue.size() > 0 ) && ( write_queue[0].timestamp <= timestamp ) )
          begin
            write_task wt = write_queue.pop_front();
            this.ram.write( wt.address, wt.data, wt.byteenable );
          end

        @( this.wr_if.wr_cb );
      end
  endtask

  task run();
    fork
      this.set_waitrequest();
      this.set_write();
    join_none
  endtask

endclass
