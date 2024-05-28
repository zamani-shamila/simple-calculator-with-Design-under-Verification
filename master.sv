`define CALC_MASTER_IF	calc_master_if
`include "calc_request.sv"

  
class master;

    virtual calc_if.Master calc_master_if;

    // Mailboxes
    mailbox #(calc_request) gen2mas, mas2scb;
    bit verbose;

    function new(virtual calc_if.Master calc_master_if, 
                 mailbox #(calc_request) gen2mas, mas2scb,
                 bit verbose=0);

      this.gen2mas        = gen2mas;
      this.mas2scb        = mas2scb;    
      this.calc_master_if = calc_master_if;
      this.verbose        = verbose;
    endfunction: new
    
    task main();
       calc_request tr;

       if(verbose)
         $display($time, ": Starting Generator");
       forever begin
        gen2mas.get(tr);
        //if (tr.reset==0) begin
          sendRequest(tr);
        //end
        //else begin
        //    reset_task();
        //end
      end

       if(verbose)
         $display($time, ": Ending tests");
    endtask: main
    
  task  sendRequest(calc_request tr);
     @(posedge `CALC_MASTER_IF.PClk)
     `CALC_MASTER_IF.Rst  <= tr.reset;
     `CALC_MASTER_IF.PCmd  <= tr.cmd;
     `CALC_MASTER_IF.PData <= tr.data;
     `CALC_MASTER_IF.PTag <= tr.tag;
     @(posedge `CALC_MASTER_IF.PClk)
     `CALC_MASTER_IF.Rst  <= tr.reset;
     `CALC_MASTER_IF.PCmd  <= 4'b0000;
     `CALC_MASTER_IF.PData <= tr.data2;
     `CALC_MASTER_IF.PTag <= 2'b00;
     
     mas2scb.put(tr);
  endtask: sendRequest
  
  task reset_task();
      `CALC_MASTER_IF.Rst <= 1;
      `CALC_MASTER_IF.PCmd  <= 0;
      `CALC_MASTER_IF.PData <= 0;
      `CALC_MASTER_IF.PTag <= 0;
      repeat(1) @(posedge `CALC_MASTER_IF.PClk);
      `CALC_MASTER_IF.Rst <= 0;
   endtask: reset_task
   task reset();
      `CALC_MASTER_IF.Rst <= 1;
      `CALC_MASTER_IF.PCmd  <= 0;
      `CALC_MASTER_IF.PData <= 0;
      `CALC_MASTER_IF.PTag <= 0;
      repeat(4) @(posedge `CALC_MASTER_IF.PClk);
      `CALC_MASTER_IF.Rst <= 0;
   endtask: reset

endclass: master

