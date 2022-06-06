//vlog -sv test_nik_pkg.v;vlog -sv test_nik.v;quit -sim;vsim work.test_nik;add wave *;run 10

//`default_nettype none
`define DEF 89
localparam IK = 99;
import globe::*;


//-----------------------------------------------------
module wrapper #(parameter SIZE, bit TEST=1) (input wire din_0, din_1, sel, output logic wr_out, [SIZE-1:0] unused = 'hAB);

initial $display("DEF wrapper = %d", `DEF);
initial $display("SIZE = %d", SIZE);
initial $display("TEST = %d", TEST);

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



logic [7:0] woof;
logic [7:0] pipi, popo [4:0];

logic [7:0] kiki, koko, kaka [4:0];

always_comb kiki = '0;
always_comb koko = '1;
always_comb kaka = '{default:0};

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

