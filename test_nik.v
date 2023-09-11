// PAGE 880
//vlog -sv test_nik_pkg.v;vlog -sv test_nik.v;quit -sim;vsim work.test_nik;add wave *;run 10

//`default_nettype none
`define DEF 89
localparam IK = 99;
import globe::*;


//-----------------------------------------------------
// extand a signal of certain nb of bit
logic [15:0] c2h_wr_ptr_relative
// resize port
ull_qm_slicer (
  .i_clk               (i_pcie_clk), //input  logic
  .i_ptr_wr            (32'(c2h_wr_ptr_relative)) //input  logic [31:0]
)
//-----------------------------------------------------
module wrapper #(parameter SIZE =2**7, bit TEST=1) (input wire din_0, din_1, sel, output logic wr_out, [SIZE-1:0] unused = 'hAB);

initial $display("DEF wrapper = %d", `DEF);
initial $display("SIZE = %d", SIZE);
initial $display("TEST = %d", TEST);

localparam T = 'h123;
initial $display(">> %0h, %s ", T, $sformatf("%0h", T));

initial begin: CHECK_PARAMETER
    if(2**($clog2(SIZE)) != SIZE) $error("SIZE = '%d' is not valid", SIZE);
end

logic [SIZE-1:0] A, B;
always_comb A = '1;
always_comb B = {SIZE{1'b1}};
//always @(*) mux_out = (sel) ? din_1 : din_0;
//always_comb mux_out = (sel) ? din_1 : din_0;
//always_comb mux_out = 1'b1;
always_comb begin
	wr_out = (sel) ? din_1 : din_0;
end

endmodule
//-----------------------------------------------------
//module test_nik(input wire logic din_0, din_1, sel, output logic mux_out, output wire unused); //default is WIRE
module test_nik(input wire logic din_0, din_1, sel, output logic mux_out); //default is WIRE
//import globe::*;
initial $strobe("DEF1 = %d", `DEF);
initial $display("DEF2 = %d", `DEF);
initial $monitor("DEF3 = %d", `DEF);

initial $display("TEST_BLOB = %d", TEST_BLOB);

initial $display("IK = %d", IK);
//assign IK = 66; //cause error

localparam DK = 78;
initial $display("DK = %d", DK);

enum {FETCH, DECODE, EXEC} STATE;
//typedef enum {FETCH, WOOF} MY_MA; //cant declare element twice
typedef enum {TOTO, WOOF} MY_MA;
MY_MA MAMA;

wrapper #(.SIZE(4)) MY_W(.din_0, .din_1, .sel, .wr_out(mux_out), .unused());
always_comb begin
	MAMA = MAMA.first;
	MAMA = MAMA.last;
end

// ------------------------ //
// INSIDE
localparam c = 2 inside {1, 2, 3};
localparam d = 7 inside {1, 2, 3};
initial $display(">>Here!1 %0d vs %0d", c, d);

localparam [31:0] g [2:0] = '{1,2,3};
localparam h = 2 inside {g};
localparam k = 7 inside {g};
initial $display(">>Here!2 %0d vs %0d", h, k);
// ------------------------ //

logic [7:0] woof;
logic [7:0] pipi, popo [4:0];

logic [7:0] kiki, koko, kaka [4:0];

always_comb kiki = '0;
always_comb koko = '1;
always_comb kaka = '{default:0};

// FOR LOOP
initial begin
    for ( int i = 0, j = 0, e = 6; i <= 3; i++, j+=8)
        $display("Value i,j,e = %0d, %0d, %0d\n", i,j,e );
    //Value i,j,e = 0, 0, 6
    //Value i,j,e = 1, 8, 6
    //Value i,j,e = 2, 16, 6
    //Value i,j,e = 3, 24, 6
end



// FOREACH LOOP
logic [1:0][2:0] test_for;
initial begin
  foreach (test_for[i, j])
    $display("foreach i,j = %0d, %0d\n", i,j);
    // foreach i,j = 1, 2
    // foreach i,j = 1, 1
    // foreach i,j = 1, 0
    // foreach i,j = 0, 2
    // foreach i,j = 0, 1
    // foreach i,j = 0, 0
end


//always_comb unused = 'z;
assign unused = 'z;  //must assign because inout must be net, net can go in 'always', net must use assign

// UNION
typedef union packed {
  logic [7:0] A;
  logic [7:0] B;
} t_AB;

t_AB AB;
always_comb AB.A = 8'hAA;

// dynamic cast seem impossible
bit[7:0] t;
bit[15:0] a = 'hFF00;
//always_comb t = a.A; //ERROR
//always_comb t = t_AB'(a); // no error but not what i want
//always_comb t = t_AB'(a).A; // ERROR
//always_comb t = t_AB'(a.A);

typedef union packed {
  logic [3:0][7:0] bytes;
} t_b;
t_b b_u = 'h0102_0304;

byte b1,b2;
assign b1 = b_u.bytes[2];
assign b2 = b_u[2*8+:8];


// STRUCT
typedef struct {bit WS, OE;} CON;
struct {bit [15:0] ADDR, DATA; CON CBUS;}  BUS;

typedef struct packed{
    logic [63:0][7:0]  a64x8_tdata;
    logic [63:0]       v64_tkeep;
  } ts_rx_dma_axis;

ts_rx_dma_axis axis_out = '{v64_tkeep:'1, default:'0};

//-----------------------------------------------------------
// assign 1 signal to other, like (others=>) in vhdl
logic a, b;
logic c, d;

// always_comb {a, b} = {default: i_axi4l_master.awvalid}; // This do a NOTE in Modelsim
always_comb {c, d} = '{default: i_axi4l_master.awvalid};
//-----------------------------------------------------------


logic [7:0] t,
logic [7:0] t1

typedef struct {
    logic             [7:0] feature = 8;
    logic             [7:0] sub_feature = 'h1;
    logic             [7:0] technologie = 'h2;
    logic             [7:0] reseversed = 'h4;
  } TTEST;
  TTEST TEST; //Need to create the type THEN create the varaible otherwise Vivado dont work

  assign t = TEST.feature;
  assign t1 = TEST.technologie;

assign BUS.CBUS.WS = 1;
//assign BUS.DATA = 8'hC;
//assign BUS.DATA = 2'hC; //put 0 since C = 0100
assign BUS.DATA = 12; //put 0 since C = 0100
//assign BUS.ADDR = 4'hC; //minimum to work
assign BUS.ADDR = 'hC; //no need length in hex
CON var_con;


// shift arithmetic
logic [3:0] a = 'b1000;
wire [3:0] b = {1'b1, a} >> 2; //0110
wire [3:0] c = {1'b1, a} >>> 2; //0110
wire [3:0] d = signed'({1'b1, a}) >>> 2; //1110

//shift array by to level
bit [3:0][7:0] tdata;
bit [7:0][7:0] data_2x;
int shift_nb = 2;
always_ff @(posedge clk)
  data_2x <= data_2x >> (($bits(tdata)/$size(tdata)) * shift_nb); // is equal to >> (2*8)

//Clock and increment
logic clk = 0;

initial begin
    forever #1 clk = ~clk;
end

logic [7:0] cnt1 = '0;
logic [7:0] cnt2 = 0;
logic [7:0] cnt3 = '{default:0};
byte        cnt4 = '0;
shortint    cnt5 = 0;
int         cnt6 =  '{default:0};

always_ff @(posedge clk) begin: NAMED_BLOCK
    cnt1 = cnt1 + 1;
    cnt2 += 1;
    cnt3 ++;
    cnt4 = cnt4 + 1'b1	;
    cnt5 = cnt5 + 'b1	;
    cnt6 = cnt6 + 'h1	;
end


initial $display("woof !");

//streaming

logic [15:0] B;
logic [15:0] C;
logic [15:0] D;
logic [15:0] E;
logic [15:0] F;
logic [15:0] G;
logic [15:0] H;
logic [15:0] I;

always_comb begin
    static logic [15:0] A = 'h1234;


    B = {<<{A}}; //inverse bit
    {>>{C}} = A; // nothing, expected
    //{>>4{C}} = A; // nothing, same as >>1
    D = {>>{A}}; // nothing, expected

    E = {4>>{A}}; // this mean 4 shift by A
    F = {>>4{A}}; // nothing, same as >>1

    G = {4<<{A}}; // this mean 4 shift by A
    H = {<<4{A}}; // inverse hex => h4321
    //H = {>>4{<<4{A}}}; // illegal
    I = {<<8{A}}; // inverse bytes => h3412
end

//concate replicator
logic [15:0] A1;
logic [15:0] C1;
logic [7:0] B1 = 6;

always_comb begin
  A1 = {B1, B1};
  C1 = {2{B1}};
end

// struct default (check with Vivado)
// MUST USE typedef OR WONT WORK !!
  typedef struct {
    logic             [7:0] feature = 3;
    logic             [7:0] sub_feature = 'h1;
    logic             [7:0] technologie = 'h2;
    logic             [7:0] reseversed = 'h4;
  } TTEST;
    TTEST TEST;

  typedef struct {
    TTEST TEST = '{feature:1, default:0};
    logic             [7:0] caca = 'h1;
  } TTEST2;
    TTEST2 TEST2;


  assign t0 = TEST.feature; // 3
  assign t1 = TEST2.TEST.feature // 1;

  //-----------------------------------------------------
  function automatic string get_license_str (int i);
    string s;
    s.hextoa(i);
    return {"iporthgn_",s};
  endfunction

endmodule
//-----------------------------------------------------
module test(
    input A, CLK,
    output logic B
    );

    logic d;
    logic o;


    always_ff @(posedge CLK) begin
        //create 2 flipflop
        B = d;
        d = A;

        //create 1 flipflop
        //d = A;
        //B = d;

        //create 1 flipflop
        //d = A;
        //B <= d;

        //create 2 flipflop
        //B <= d;
        //d = A;

        //create 2 flipflop
        //d <= A;
        //B <= d;

        //create 2 flipflop
        //B <= d;
        //d <= A;

        //output to 0
        //B <= 1;
        //B <= 0;

        //output to 1
        //B <= 0;
        //B <= 1;
    end


    //assign B <= 1; //illegal

    //output to 1
    //assign B = 0;
    //assign B = 1;
endmodule
//-----------------------------------------------------

