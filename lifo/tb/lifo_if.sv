interface lifo_if #(
  parameter int unsigned DWIDTH,
  parameter int unsigned AWIDTH
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

endinterface
