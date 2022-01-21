// vlog -svinputport=relaxed test.sv;vsim test;log /*;run 1ns
// PAGE 170
package l2_pkg;
  typedef struct packed {logic [7:0] a,b;} ab;
//  function automatic int Tsum (input int driver[]); // UNSUPPORTED
//      Tsum = 0;
//      foreach (driver[i])
//        Tsum += driver[i];
//  endfunction
endpackage

`define OTIPREFIX OTIMACPCS10G_32_
`define NAME mac_pcs_ip

//`define FULLNAME `OTIPREFIX``mac_pcs_ip
`define append(f,g) f```g
`define FULLNAME `OTIPREFIX``mac_pcs_ip

`define MOD(MODNAME) MODNAME

`define to_str(x) `"x`"

module test import l2_pkg::*; (input logic [7:0] i1, i2,output logic [7:0] a,b,c,d,e,f,g, output logic [7:0] u1, output logic [3:0] u2, u3);
  //initial $display(">>1 %s", `to_str(`FULLNAME));
  initial $display(">>2 %s", `to_str(`OTIPREFIX`MOD(mac_pcs_ip)));
  wire u = i1 & i2;
  assign f = u;
  
//  int kk [1:0] = {1,2};
//  assign g = Tsum(kk);

  //--------------------------------------
  typedef union packed {
    struct packed{
      bit [3:0] reg2;
      bit [3:0] reg1;
    } add;
    bit [7:0] test;
  } instr;
  
  instr i = 'b1100_0101;
  assign u1 = i.test;
  assign u2 = i.add.reg1;
  assign u3 = i.add.reg2;
  
   //--------------------------------------
  ab v;
  assign v = '{a:1, b:2};
  assign a = v.a;
  assign b = v.b;
  assign c = '{2:1'b0, default:1'b1};
  subtest subtest(.i('{a:3, b:4}), .o(d), .o1(e));
endmodule

//--------------------------------------
module subtest import l2_pkg::*; (input ab i,output [7:0] o,o1);
  assign o=i.a;
  assign o1=i.b;
endmodule