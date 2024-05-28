`ifndef CALC_IF_DEFINE
`define CALC_IF_DEFINE


parameter CALC_CMD_WIDTH = 4;
typedef bit [CALC_CMD_WIDTH-1:0] reg_cmd_t;
parameter CALC_DATA_WIDTH = 32;
typedef bit [CALC_DATA_WIDTH-1:0] req_data_t;

interface calc_if(input PClk);
    logic [CALC_CMD_WIDTH-1:0]  PCmd;
    logic [CALC_DATA_WIDTH-1:0]  PData;
    logic [1:0] PTag;

    //Input for DUT
    logic [CALC_CMD_WIDTH-1:0] req1_cmd_in;
    logic [CALC_CMD_WIDTH-1:0] req2_cmd_in;
    logic [CALC_CMD_WIDTH-1:0] req3_cmd_in;
    logic [CALC_CMD_WIDTH-1:0] req4_cmd_in;

    logic [CALC_DATA_WIDTH-1:0]  req1_data_in;
    logic [CALC_DATA_WIDTH-1:0]  req2_data_in;
    logic [CALC_DATA_WIDTH-1:0]  req3_data_in;
    logic [CALC_DATA_WIDTH-1:0]  req4_data_in;

    logic [1:0]  req1_tag_in;
    logic [1:0]  req2_tag_in;
    logic [1:0]  req3_tag_in;
    logic [1:0]  req4_tag_in;

    logic Rst;

    //Output for DUT
    wire [1:0]  out_resp1;
    wire [1:0]  out_resp2;
    wire [1:0]  out_resp3;
    wire [1:0]  out_resp4;

    wire [CALC_DATA_WIDTH-1:0]  out_data1;
    wire [CALC_DATA_WIDTH-1:0]  out_data2;
    wire [CALC_DATA_WIDTH-1:0]  out_data3;
    wire [CALC_DATA_WIDTH-1:0]  out_data4;   
    
    wire [1:0]  out_tag1;
    wire [1:0]  out_tag2;
    wire [1:0]  out_tag3;
    wire [1:0]  out_tag4;
    
    //Clock
    //bit Clk;

    always @ (posedge PClk) begin
        //Use the calc_request input to drive all 4 ports at the same time
        req1_cmd_in <= PCmd;
        req2_cmd_in <= PCmd;
        req3_cmd_in <= PCmd;
        req4_cmd_in <= PCmd;
    
        req1_data_in <= PData;
        req2_data_in <= PData;
        req3_data_in <= PData;
        req4_data_in <= PData;

        req1_tag_in <= PTag;
        req2_tag_in <= PTag;
        req3_tag_in <= PTag;
        req4_tag_in <= PTag;
        
    end

  modport Master(input PClk, output PCmd, PData, PTag, Rst);
  modport Monitor(input PClk, out_resp1, out_resp2, out_resp3, out_resp4,
                        out_data1, out_data2, out_data3, out_data4,
                        out_tag1, out_tag2, out_tag3, out_tag4
                        );
  
  modport Slave(input   req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in,
                        req1_data_in, req2_data_in, req3_data_in, req4_data_in,
                        req1_tag_in, req2_tag_in, req3_tag_in, req4_tag_in,
                output  out_resp1, out_resp2, out_resp3, out_resp4,
                        out_data1, out_data2, out_data3, out_data4,
                        out_tag1, out_tag2, out_tag3, out_tag4
                );
  

endinterface

`endif    


