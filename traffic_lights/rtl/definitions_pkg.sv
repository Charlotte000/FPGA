package definitions_pkg;

typedef enum logic [2:0]
{
  SET_ON     = 3'd0,
  SET_OFF    = 3'd1,
  SET_MANUAL = 3'd2,
  SET_GREEN  = 3'd3,
  SET_RED    = 3'd4,
  SET_YELLOW = 3'd5
} command_e;

typedef enum
{
  RED_S,
  RED_YELLOW_S,
  GREEN_S,
  GREEN_BLINK_S,
  YELLOW_S,
  MANUAL_S,
  OFF_S
} state_e;

endpackage
