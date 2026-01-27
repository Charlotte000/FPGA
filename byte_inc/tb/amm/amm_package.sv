package amm_package;

enum
{
  SLOW,
  FAST,
  RANDOM
} ram_speed = RANDOM;

int unsigned RD_WAIT_MIN           = 1;
int unsigned RD_WAIT_MAX           = 64;
int unsigned RD_WAITREQUEST_CHANCE = 50;

int unsigned WR_WAIT               = 1;
int unsigned WR_WAITREQUEST_CHANCE = 50;

function int unsigned get_rd_wait_count();
  case( ram_speed )
    FAST:
      return RD_WAIT_MIN;
    SLOW:
      return RD_WAIT_MAX;
    RANDOM:
      return $urandom_range( RD_WAIT_MIN, RD_WAIT_MAX );
    default:
      return $urandom_range( RD_WAIT_MIN, RD_WAIT_MAX );
  endcase
endfunction

`include "amm_ram.sv"

`include "rd/amm_driver_rd.sv"
`include "rd/amm_monitor_rd.sv"
`include "rd/amm_agent_rd.sv"

`include "wr/amm_driver_wr.sv"
`include "wr/amm_monitor_wr.sv"
`include "wr/amm_agent_wr.sv"

endpackage
