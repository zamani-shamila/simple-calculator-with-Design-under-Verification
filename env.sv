`include "calc_if.sv"
`include "calc_request.sv"
`include "master.sv"
`include "monitor.sv"
`include "result.sv"
`include "generator.sv"
`include "scoreboard.sv"

////////////////////////////////////////////////////////////
class test_cfg;   
  int trans_cnt = 100;
endclass: test_cfg
class env;

  test_cfg    tcfg;
  //Transactors
  generator     gen;
  master  mst;
  monitor mon;
  scoreboard  scb;
  // Mailboxs
  mailbox #(calc_request) gen2mas, mas2scb;
  mailbox #(result) mon2scb;
  //Interface
  virtual calc_if vintfc;
  function new(virtual calc_if vintfc);
    this.vintfc  = vintfc;
    gen2mas   = new();
    mas2scb   = new();
    mon2scb   = new();
    tcfg      = new();
    if (!tcfg.randomize()) 
      begin
        $display("test_cfg::randomize failed");
        $finish;
      end
    gen= new(gen2mas, tcfg.trans_cnt, 1);
    mst= new(this.vintfc, gen2mas, mas2scb, 1);
    mon= new(this.vintfc, mon2scb);
    scb= new(tcfg.trans_cnt, mas2scb, mon2scb);
  endfunction: new
  virtual task pre_test();
    scb.max_trans_cnt = gen.max_trans_cnt;
    fork
      scb.main();
      mst.main();
      mon.main();
    join_none
  endtask: pre_test
  virtual task test();
    mst.reset();
    fork
      gen.main();
    join_none
  endtask: test
  virtual task post_test();
    fork
      wait(gen.ended.triggered);
      wait(scb.ended.triggered);
    join
  endtask: post_test


  task run();
    pre_test();
    test();
    post_test();
  endtask: run

endclass: env


