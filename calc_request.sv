`ifndef CALC_REQUEST_DEFINE
`define CALC_REQUEST_DEFINE

class calc_request;
    rand bit [3:0] cmd;
    rand bit [31:0] data;
    rand bit [31:0] data2;
    static int count=0;
    bit [1:0] tag;
    int id, trans_cnt;
    bit reset=0;
    function new;
    id = count++;
    tag = id;
    endfunction
  function calc_request copy();
    calc_request to   = new();
    to.cmd=this.cmd;
    to.data=this.data;
    to.data2=this.data2;
    to.reset=this.reset;
    copy=to;
  endfunction: copy
    
endclass

`endif


