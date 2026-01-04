interface lifo_if #(
  parameter int unsigned DWIDTH = 16,
  parameter int unsigned AWIDTH = 8
)(
  input logic clk,
  input logic srst
);

logic              wrreq;
logic [DWIDTH-1:0] data;
logic              rdreq;
logic [DWIDTH-1:0] q;
logic              almost_empty;
logic              empty;
logic              almost_full;
logic              full;
logic [AWIDTH:0]   usedw;

modport tx (
  input clk,
  input srst,
  input wrreq,
  input data,
  input rdreq
);

modport rx (
  input  clk,
  input  srst,

  output q,
  output almost_empty,
  output empty,
  output almost_full,
  output full,
  output usedw
);

endinterface
