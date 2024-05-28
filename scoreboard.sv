`include "calc_request.sv"
`include "result.sv"

class scoreboard;

  typedef enum {CORRECT, INCORRECT} calc_check_result;
  
  bit verbose;
  int max_trans_cnt;
  event ended;
  int match;
  calc_request mas_tr;
  result mon_tr; 
  bit [31:0] expected_data_array[3:0];
  bit [31:0] expected_val;
  mailbox #(calc_request) mas2scb;
  mailbox #(result) mon2scb;   
  calc_check_result result_check;
  calc_request request_array[3:0];
  
    covergroup cg_input;
        //input request
        request_cmd: coverpoint mas_tr.cmd {
          bins a = {4'b0001};
          bins b = {4'b0010};
          bins c = {4'b0101}; 
          bins d = {4'b0110};
        }
        request_data: coverpoint mas_tr.data;
        request_data2: coverpoint mas_tr.data2;
    endgroup
    
    covergroup cg_output;
        
        //output value
        output_resp: coverpoint mon_tr.out_Resp{
          bins a = {2'b01};
          bins b = {2'b10};
        }
        output_data: coverpoint mon_tr.out_Data;
        output_correctness: coverpoint result_check;
    endgroup

  // Constructor
  function new(int max_trans_cnt, mailbox #(calc_request) mas2scb, mailbox #(result) mon2scb, bit verbose=0);
    this.max_trans_cnt = max_trans_cnt;
	this.mon2scb       = mon2scb;
    this.mas2scb       = mas2scb;
    this.verbose       = verbose;
    
    cg_input = new();
    cg_output = new();
  endfunction
  
  task main();
    fork
        forever begin
            mas2scb.get(mas_tr);//input
            cg_input.sample();
            request_array[mas_tr.tag] = mas_tr;
            case(mas_tr.cmd)
            //add
            4'b0001:
                begin
                    expected_val = mas_tr.data + mas_tr.data2;
                    expected_data_array[mas_tr.tag] = expected_val;
                end
            //subtract		
            4'b0010:
                begin
                    expected_val = mas_tr.data - mas_tr.data2;
                    expected_data_array[mas_tr.tag] = expected_val;				
                end
            //shift	left		
            4'b0101:
                begin
                    expected_val = mas_tr.data << mas_tr.data2[4:0];
                    expected_data_array[mas_tr.tag] = expected_val;
                end
            //shift right				
            4'b0110:
                begin
                    expected_val = mas_tr.data >> mas_tr.data2[4:0];
                    expected_data_array[mas_tr.tag] = expected_val;
                end
          default:
                begin
                  $display("@%0d: Fatal error: Scoreboard received illegal master transaction", $time);
                end
            endcase
        end
        
        forever begin
            mon2scb.get(mon_tr);
            result_check = CORRECT;
            expected_val = expected_data_array[mon_tr.out_Tag];
            
            if (mon_tr.out_Resp === 2'b00) begin
              $display("@%0d: On port #: %d ERROR No esponce",
						  $time, mon_tr.out_Port );
					
			end else begin
        if((request_array[mon_tr.out_Tag].cmd== 4'b0100) )  begin
           $display("@%0d: On port #: %d, Cmd: %04b, Invalid Command", $time,mon_tr.out_Port,request_array[mon_tr.out_Tag].cmd);
        end else if(request_array[mon_tr.out_Tag].cmd == 4'b0011)begin   
          $display("@%0d: On port #: %d, Cmd: %04b, Invalid Command", $time,mon_tr.out_Port,request_array[mon_tr.out_Tag].cmd);
        end else begin
           if (mon_tr.out_Data !== expected_val) begin
					$display("@%0d: On port #: %d, Cmd: %04b, tag: %d, Data1: %h, Data2: %h, ERROR, monitor data (%h) does not match Expected Value (%h)",
						$time, mon_tr.out_Port, request_array[mon_tr.out_Tag].cmd, mon_tr.out_Tag, request_array[mon_tr.out_Tag].data, request_array[mon_tr.out_Tag].data2, mon_tr.out_Data, expected_val);
					result_check = INCORRECT;
				   end else begin
					$display("@%0d: On port #: %d, Cmd: %04b, tag: %d, Data1: %h, Data2: %h, CORRECT, monitor data (%h) does match Expected Value (%h)",
						$time, mon_tr.out_Port, request_array[mon_tr.out_Tag].cmd, mon_tr.out_Tag, request_array[mon_tr.out_Tag].data, request_array[mon_tr.out_Tag].data2, mon_tr.out_Data, expected_val);
				end
        end
			end
            cg_output.sample();
            if(--max_trans_cnt<1) ->ended;
            
        end 
    join_none
    
  endtask

endclass
