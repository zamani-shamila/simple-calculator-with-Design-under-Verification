`include "env.sv"

program automatic test(calc_if intf);

  env enviro;

  initial begin

    enviro = new(intf);
    enviro.run();
    //#1000
    $finish;
  end 

endprogram

