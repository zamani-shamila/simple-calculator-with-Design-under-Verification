`ifndef CALC_RESULT_DEFINE
`define CALC_RESULT_DEFINE

class result;
    bit [1:0] out_Resp;
    bit [31:0] out_Data;
    bit [1:0] out_Tag;
    integer out_Port;
  
    
  function result copy();
    result to = new();
    to.out_Resp= this.out_Resp;
    to.out_Data= this.out_Data;
    to.out_Tag= this.out_Tag;
    to.out_Port= this.out_Port;
    copy = to;
  endfunction: copy
    
endclass

`endif


