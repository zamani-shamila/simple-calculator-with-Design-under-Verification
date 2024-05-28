`include "calc_request.sv"

class generator;

  
  // Non_random Variables
  parameter  overflow_test_length = 47;
  bit [3:0]  overflow_test_cmd[overflow_test_length]= '{4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001, 
                                                        4'b0010,  4'b0010, 4'b0010, 4'b0010, 4'b0010, 4'b0010,
                                                        4'b0101, 4'b0101, 4'b0101,
                                                        4'b0110, 4'b0110, 4'b0110,
                                                        4'b001,4'b001,4'b001,4'b001,4'b001,4'b001,4'b001,                                               
                                                        4'b010,4'b010,4'b010,4'b010,                            
                                                        4'b101,4'b101,4'b101,4'b101,4'b101,4'b101                                        ,
                                                        4'b110,4'b110,4'b110,4'b110,4'b110,4'b110,4'b110};
  
  
  bit [31:0] overflow_test_data[overflow_test_length]= '{32'h00000001, 32'h00000000, 32'h00000000, 32'h0000000A, 32'h00000005, 32'h00000001, 32'h7FFFFFFE, 32'h0000000F, 32'hF0000001, 32'h00000001, 32'hFFFFFFFE,
                                                         32'h00000000, 32'h00000001, 32'h00000005, 32'h0000000A, 32'h7FFFFFFE, 32'h80000001,
                                                         32'hFFFFFFFF, 32'hAAAAAAAA, 32'hAAAAAAAA,
                                                         32'hFFFFFFFF, 32'h55555555, 32'h55555555,
                                                          32'hFFFFFFFF,32'hFFFFFFFF,32'h00000000,32'hFFFFFFFE,32'h00000000,32'hFFFFFF11,32'h0000000B,    
                                                          32'h000001C8,32'hBBBBBBCC,32'h0000022B,32'h00000000,    
                                                          32'h00000000,32'h000AFFFF,32'hFFFFFFFF,32'hFFFFFFFF,32'h11115555,32'h000AFFFF   
                                                          ,32'h00000000,32'h000AFFFF,32'hFFFFFFFF,32'hFFFFFFFF,32'h11115555,32'h00000001,32'h00000001};

  
  
  bit [31:0] overflow_test_data2[overflow_test_length]= '{32'h00000001, 32'h00000000, 32'h00000000, 32'h0000000A, 32'h00000005, 32'h00000001, 32'h7FFFFFFE, 32'h0000000F, 32'hF0000001, 32'h00000001, 32'hFFFFFFFE,
                                                          32'h00000000, 32'h00000001, 32'h0000000A, 32'h00000005, 32'h80000001, 32'h80000001,
                                                          32'h0000001F, 32'h00000001, 32'hA5A5FFE1,
                                                          32'h0000001F, 32'h00000001, 32'hA5A5FFE1,
                                                          32'hFFFFFFFF,32'h00000000,32'hFFFFFFFF,32'h00000001,32'h00000000,32'h000111EE,32'h00000004,    
                                                          32'h00000007,32'hBBBBBBCD,32'h0000022B,32'h00000000,   
                                                          32'h00000000,32'h00000004,32'h00000001,32'h000000FF,32'h00000099,32'h00000000   
                                                          ,32'h00000000,32'h00000004,32'h00000001,32'h000000FF,32'h00000099,32'h00000000,32'h00000001  };
  

  bit is_rand = 0;
  bit verbose;
  event ended;
  rand calc_request rand_tr;
  int max_trans_cnt;


  // parameter  overflow_test_length = 1;

  // bit [3:0]  overflow_test_cmd[overflow_test_length]= '{4'b110};
  // bit [31:0] overflow_test_data[overflow_test_length]= '{32'h00000099};
  // bit [31:0] overflow_test_data2[overflow_test_length]= '{32'hFFFFFFFF};
  


  // //Invalid Command test
  // parameter  overflow_test_length = 6;
  // bit [3:0]  overflow_test_cmd[overflow_test_length]= '{  
  //                                                       4'b011,4'b011,4'b011,                             
  //                                                       4'b100,4'b100,4'b100 };
  
  // bit [31:0] overflow_test_data[overflow_test_length]= '{32'hb0677a12,32'h59634190,32'h8a0d3e5b,           
  //                                                         32'hb0677a12,32'h59634190,32'h8a0d3e5b     };

  // bit [31:0] overflow_test_data2[overflow_test_length]= '{32'h125c8c16,32'h922b4f0f,32'h125c8c16,           
  //                                                         32'h125c8c16,32'h922b4f0f,32'h125c8c16   };
  

  
  // Counts the number of performed transactions
  int trans_cnt = 0;
  int tr_numb =49;
  // Mailboxs
  mailbox #(calc_request) gen2mas;

  function new(mailbox #(calc_request) gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    rand_tr            = new;
  endfunction


  task main();
    if(verbose)
      $display($time, ": Starting generator for %0d transactions", max_trans_cnt);
    while(!end_of_test())
      begin

        calc_request my_tr;

        if (trans_cnt < overflow_test_length) begin
          my_tr = overflow_test();
		end
/*		
     else if (trans_cnt==48) begin
          my_tr = get_transaction();
        end

      
     else if (trans_cnt==tr_numb) begin
          my_tr = traffic_add();
        end
        else if (trans_cnt==tr_numb+1) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+2 || trans_cnt==tr_numb+3) begin
          my_tr = traffic_add();
        end
        else if (trans_cnt==tr_numb+4 || trans_cnt==tr_numb+5) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+6 || trans_cnt==tr_numb+7 || trans_cnt==tr_numb+8 || trans_cnt==tr_numb+9) begin
          my_tr = traffic_add();
        end
        else if (trans_cnt==tr_numb+10 || trans_cnt==tr_numb+11 || trans_cnt==tr_numb+12 || trans_cnt==tr_numb+13) begin
          my_tr = get_transaction();
        end
        // subtract
        if (trans_cnt==tr_numb+14) begin
          my_tr = traffic_sub();
        end
        else if (trans_cnt==tr_numb+15) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+16 || trans_cnt==tr_numb+17) begin
          my_tr = traffic_sub();
        end
        else if (trans_cnt==tr_numb+18 || trans_cnt==tr_numb+19) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+20 || trans_cnt==tr_numb+21 || trans_cnt==tr_numb+22 || trans_cnt==tr_numb+23) begin
          my_tr = traffic_sub();
        end
        else if (trans_cnt==tr_numb+24 || trans_cnt==tr_numb+25 || trans_cnt==tr_numb+26 || trans_cnt==tr_numb+27) begin
          my_tr = get_transaction();
        end
        // SSL
        if (trans_cnt==tr_numb+28) begin
          my_tr = traffic_SSL();
        end
        else if (trans_cnt==tr_numb+29) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+30 || trans_cnt==tr_numb+31) begin
          my_tr = traffic_SSL();
        end
        else if (trans_cnt==tr_numb+32 || trans_cnt==tr_numb+33) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+34 || trans_cnt==tr_numb+35 || trans_cnt==tr_numb+36 || trans_cnt==tr_numb+37) begin
          my_tr = traffic_SSL();
        end
        else if (trans_cnt==tr_numb+38 || trans_cnt==tr_numb+39 || trans_cnt==tr_numb+40 || trans_cnt==tr_numb+41) begin
          my_tr = get_transaction();
        end
        // SSR
        if (trans_cnt==tr_numb+42) begin
          my_tr = traffic_SSR();
        end
        else if (trans_cnt==tr_numb+43) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+44 || trans_cnt==tr_numb+45) begin
          my_tr = traffic_SSR();
        end
        else if (trans_cnt==tr_numb+46 || trans_cnt==tr_numb+47) begin
          my_tr = get_transaction();
        end
        else if (trans_cnt==tr_numb+48 || trans_cnt==tr_numb+49 || trans_cnt==tr_numb+50 || trans_cnt==tr_numb+51) begin
          my_tr = traffic_SSR();
        end
        else if (trans_cnt==tr_numb+52 || trans_cnt==tr_numb+53 || trans_cnt==tr_numb+54 || trans_cnt==tr_numb+55) begin
          my_tr = get_transaction();
        end 
        */
        else begin
          my_tr = get_transaction();
        end
        
        ++trans_cnt;

        gen2mas.put(my_tr);
      end 
        
    if(verbose) 
      $display($time, ": Generator End \n");
  
    ->ended;

  endtask

  virtual function bit end_of_test();
    end_of_test = (trans_cnt >= max_trans_cnt);
  endfunction
  virtual function calc_request get_transaction();
    rand_tr.trans_cnt = trans_cnt;
    if (! this.rand_tr.randomize() with {rand_tr.cmd dist{4'b0001 := 25, 4'b0010 := 25, 4'b0101 := 25, 4'b0110 := 25};})
      begin
        $display("apb_gen:failed randomization");
        $finish;
      end

    return rand_tr.copy();
  endfunction

  virtual function calc_request overflow_test();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.cmd = overflow_test_cmd[trans_cnt];
    rand_tr.data = overflow_test_data[trans_cnt];
    rand_tr.data2 = overflow_test_data2[trans_cnt];
    return rand_tr.copy();
  endfunction

  virtual function calc_request traffic_add();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.cmd = 4'b0001;
    rand_tr.reset = 0;
    if (! this.rand_tr.randomize(data, data2))
      begin
        $display("apb_gen:failed randomization");
        $finish;
      end
    
    return rand_tr.copy();
  endfunction

  virtual function calc_request traffic_sub();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.cmd = 4'b0010;
    rand_tr.reset = 1'b0;
    if (! this.rand_tr.randomize(data, data2))
      begin
        $display("apb_gen:failed randomization");
        $finish;
      end
    return rand_tr.copy();
 endfunction

  virtual function calc_request traffic_SSL();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.cmd = 4'b0101;
    rand_tr.reset = 0;
    if  (! this.rand_tr.randomize(data,data2) with {rand_tr.data < 32'h00000020;})
      begin
        $display("apb_gen:failed randomization");
        $finish;
      end
    return rand_tr.copy();
  endfunction

    virtual function calc_request traffic_SSR();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.reset = 0;
    rand_tr.cmd = 4'b0110;
    if  (! this.rand_tr.randomize(data,data2) with {rand_tr.data < 32'h00000020;})
      begin
        $display("apb_gen:failed randomization");
        $finish;
      end
    return rand_tr.copy();
  endfunction
    
  virtual function calc_request reset();
    rand_tr.trans_cnt = trans_cnt;
    rand_tr.reset = 1;
   
    return rand_tr.copy();
  endfunction
endclass

