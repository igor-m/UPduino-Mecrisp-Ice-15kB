`timescale 1 ns / 1 ps

//`default_nettype none
`define WIDTH 16

// Modifications for 15kB block ram, and various other experiments
// by IgorM 11 Dec 2017
// Mind the SPI Flash on the UPduino board must be wired as below
// external oscillator 30 MHz

module SB_RAM256x16(
	output wire [15:0] RDATA,
	input  wire       RCLK, RCLKE, RE,
	input  wire [7:0] RADDR,
	input  wire       WCLK, WCLKE, WE,
	input  wire [7:0] WADDR,
	input  wire  [15:0] MASK, WDATA
);
	parameter INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

  wire [15:0] rd;

  SB_RAM40_4K #(
    .WRITE_MODE(0),
    .READ_MODE(0),
    .INIT_0(INIT_0),
    .INIT_1(INIT_1),
    .INIT_2(INIT_2),
    .INIT_3(INIT_3),
    .INIT_4(INIT_4),
    .INIT_5(INIT_5),
    .INIT_6(INIT_6),
    .INIT_7(INIT_7),
    .INIT_8(INIT_8),
    .INIT_9(INIT_9),
    .INIT_A(INIT_A),
    .INIT_B(INIT_B),
    .INIT_C(INIT_C),
    .INIT_D(INIT_D),
    .INIT_E(INIT_E),
    .INIT_F(INIT_F)
  ) _ram1 (
    .RDATA(rd),
    .RADDR(RADDR),
    .RCLK(RCLK), .RCLKE(RCLKE), .RE(RE),
    .WCLK(WCLK), .WCLKE(WCLKE), .WE(WE),
    .WADDR(WADDR),
    //.MASK(16'h0000), 
	.WDATA(WDATA) );

assign RDATA = rd;

endmodule


// @@@@@@@@@@@@@@@@@@@@@@@@@@

module SB_RAM2048x2(
	output wire [1:0] RDATA,
	input  wire       RCLK, RCLKE, RE,
	input  wire [10:0] RADDR,
	input  wire       WCLK, WCLKE, WE,
	input  wire [10:0] WADDR,
	input  wire [1:0] MASK, WDATA
);
	parameter INIT_0 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_1 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_2 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_3 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_4 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_5 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_6 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_7 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_8 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_9 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
	parameter INIT_F = 256'h0000000000000000000000000000000000000000000000000000000000000000;

  wire [15:0] rd;

  SB_RAM40_4K #(
    .WRITE_MODE(3),
    .READ_MODE(3),
    .INIT_0(INIT_0),
    .INIT_1(INIT_1),
    .INIT_2(INIT_2),
    .INIT_3(INIT_3),
    .INIT_4(INIT_4),
    .INIT_5(INIT_5),
    .INIT_6(INIT_6),
    .INIT_7(INIT_7),
    .INIT_8(INIT_8),
    .INIT_9(INIT_9),
    .INIT_A(INIT_A),
    .INIT_B(INIT_B),
    .INIT_C(INIT_C),
    .INIT_D(INIT_D),
    .INIT_E(INIT_E),
    .INIT_F(INIT_F)
  ) _ram (
    .RDATA(rd),
    .RADDR(RADDR),
    .RCLK(RCLK), .RCLKE(RCLKE), .RE(RE),
    .WCLK(WCLK), .WCLKE(WCLKE), .WE(WE),
    .WADDR(WADDR),
    //.MASK(16'h0000), 
	.WDATA({4'b0, WDATA[1], 7'b0, WDATA[0], 3'b0}));

  assign RDATA[0] = rd[3];
  assign RDATA[1] = rd[11];

endmodule

module top(
			input wire oscillator,

			output wire TXD,        // UART TX
			input  wire RXD,        // UART RX

			output wire SPICLK,    // Flash SCK  --- fpga spiclk  pin 15
			input  wire SPISO,     // Flash SDO  --- fpga spisi   pin 17
			output wire SPISI,     // Flash SDI  --- fpga spiso   pin 14
			output wire SPISSB,    // Flash CS   --- fpga spissb  pin 16

			output wire PIO1_18,    // IR TXD
			input  wire PIO1_19,    // IR RXD
			output wire PIO1_20,    // IR SD

			inout wire PORTA0,
			inout wire PORTA1,
			inout wire PORTA2,
			inout wire PORTA3,
			inout wire PORTA4,
			inout wire PORTA5,
			inout wire PORTA6,
			inout wire PORTA7,
			inout wire PORTA8,
			inout wire PORTA9,
			inout wire PORTA10,
			inout wire PORTA11,
			inout wire PORTA12,
			inout wire PORTA13,
			inout wire PORTA14,
			inout wire PORTA15,
 
			input wire resetq
);



  wire clk ;
  assign clk = oscillator;

 //my_pll my_pll_inst(.REFERENCECLK(oscillator),
 //                  .PLLOUTCORE(Hclk),
 //                  .PLLOUTGLOBAL(),
 //                  .RESET(1'b1)      );


  wire io_rd, io_wr;
  wire [15:0] mem_addr;
  wire mem_wr;
  wire [15:0] dout;
  wire [15:0] io_din;
  wire [12:0] code_addr;

  reg unlocked = 0;

`include "../build/ram_test.v"

  reg interrupt = 0;

  // ######   PROCESSOR   #####################################

  j1 _j1(
    .clk(clk),
    .resetq(resetq),
    .io_rd(io_rd),
    .io_wr(io_wr),
    .mem_wr(mem_wr),
    .dout(dout),
    .io_din(io_din),
    .mem_addr(mem_addr),
    .code_addr(code_addr),
    .insn_from_memory(insn),
    .interrupt_request(interrupt)
  );

// DEFINES for IOs and PERIPHERALs

`define adr_ticksl			16'd100  // 
`define adr_ticksh			16'd101  // 
`define adr_tickshh			16'd102  // 

`define adr_tickssl			16'd105  // 
`define adr_tickssh			16'd106  // 
`define adr_ticksshh			16'd107  // 
`define adr_ticksample			16'd109  // 

`define adr_timer1l			16'd110  // 
`define adr_timer1h			16'd111  // 
`define adr_timer1cl			16'd112  // 
`define adr_timer1ch			16'd113  // 
`define adr_timer1			16'd119  // 

`define adr_uart0			16'h1000 // 16'h1000

`define adr_porta_in			16'd310  // 
`define adr_porta_out			16'd311  // 
`define adr_porta_dir			16'd312  // 
 
`define adr_pios			16'h8    // 16'h8

`define adr_util1			16'h2000 // 16'h2000



  // ######   TICKS   #########################################

  reg  [47:0] ticks = 0;
  reg  [47:0] tickss = 0;

// timer ticks

  wire [47:0] ticks_plus_1 = ticks + 1;

  always @(posedge clk)
     ticks <= ticks_plus_1;

// sample the ticks with "now"

  always @(posedge clk)
    if (io_wr & (mem_addr == `adr_ticksample))  tickss[47:0] <= ticks;

// Timer1

//  reg [31:0] timer1 = 0;
//  reg [31:0] timer1c = 0;

//  wire [31:0] timer1_plus_1 = timer1 + 1;
//  always @(posedge clk)
//    if (io_wr & (mem_addr == `adr_timer1))  timer1[31:0] <= 0;
//    else
//	timer1 <= timer1_plus_1;

// Write timer1 compare
//  always @(posedge clk)
//    if (io_wr & (mem_addr == `adr_timer1cl))  timer1c[15:0] <= dout;
//    else 
//    if (io_wr & (mem_addr == `adr_timer1ch))  timer1c[31:16] <= dout;

// Compare timer1 with timer1compare
//  always @(posedge clk) // Generate interrupt on timer1 compare
//    interrupt <= (timer1 == timer1c) ? 1 : 0;




 // ######   PORTA   ###########################################

  reg  [15:0] porta_dir;   // 1:output, 0:input
  reg  [15:0] porta_out;
  wire [15:0] porta_in;

  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa0  (.PACKAGE_PIN(PORTA0),  .D_OUT_0(porta_out[0]),  .D_IN_0(porta_in[0]),  .OUTPUT_ENABLE(porta_dir[0]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa1  (.PACKAGE_PIN(PORTA1),  .D_OUT_0(porta_out[1]),  .D_IN_0(porta_in[1]),  .OUTPUT_ENABLE(porta_dir[1]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa2  (.PACKAGE_PIN(PORTA2),  .D_OUT_0(porta_out[2]),  .D_IN_0(porta_in[2]),  .OUTPUT_ENABLE(porta_dir[2]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa3  (.PACKAGE_PIN(PORTA3),  .D_OUT_0(porta_out[3]),  .D_IN_0(porta_in[3]),  .OUTPUT_ENABLE(porta_dir[3]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa4  (.PACKAGE_PIN(PORTA4),  .D_OUT_0(porta_out[4]),  .D_IN_0(porta_in[4]),  .OUTPUT_ENABLE(porta_dir[4]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa5  (.PACKAGE_PIN(PORTA5),  .D_OUT_0(porta_out[5]),  .D_IN_0(porta_in[5]),  .OUTPUT_ENABLE(porta_dir[5]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa6  (.PACKAGE_PIN(PORTA6),  .D_OUT_0(porta_out[6]),  .D_IN_0(porta_in[6]),  .OUTPUT_ENABLE(porta_dir[6]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa7  (.PACKAGE_PIN(PORTA7),  .D_OUT_0(porta_out[7]),  .D_IN_0(porta_in[7]),  .OUTPUT_ENABLE(porta_dir[7]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa8  (.PACKAGE_PIN(PORTA8),  .D_OUT_0(porta_out[8]),  .D_IN_0(porta_in[8]),  .OUTPUT_ENABLE(porta_dir[8]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa9  (.PACKAGE_PIN(PORTA9),  .D_OUT_0(porta_out[9]),  .D_IN_0(porta_in[9]),  .OUTPUT_ENABLE(porta_dir[9]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa10 (.PACKAGE_PIN(PORTA10), .D_OUT_0(porta_out[10]), .D_IN_0(porta_in[10]), .OUTPUT_ENABLE(porta_dir[10]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa11 (.PACKAGE_PIN(PORTA11), .D_OUT_0(porta_out[11]), .D_IN_0(porta_in[11]), .OUTPUT_ENABLE(porta_dir[11]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa12 (.PACKAGE_PIN(PORTA12), .D_OUT_0(porta_out[12]), .D_IN_0(porta_in[12]), .OUTPUT_ENABLE(porta_dir[12]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa13 (.PACKAGE_PIN(PORTA13), .D_OUT_0(porta_out[13]), .D_IN_0(porta_in[13]), .OUTPUT_ENABLE(porta_dir[13]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa14 (.PACKAGE_PIN(PORTA14), .D_OUT_0(porta_out[14]), .D_IN_0(porta_in[14]), .OUTPUT_ENABLE(porta_dir[14]));
  SB_IO #(.PIN_TYPE(6'b1010_01)) ioa15 (.PACKAGE_PIN(PORTA15), .D_OUT_0(porta_out[15]), .D_IN_0(porta_in[15]), .OUTPUT_ENABLE(porta_dir[15]));  
  

  // ######   UART   ##########################################

  wire uart0_valid, uart0_busy;
  wire [7:0] uart0_data;
  wire uart0_wr = io_wr & (mem_addr == `adr_uart0);
  wire uart0_rd = io_rd & (mem_addr == `adr_uart0);
  wire UART0_RX;
  buart _uart0 (
     .clk(clk),
     .resetq(1'b1),
     .rx(RXD),
     .tx(TXD),
     .rd(uart0_rd),
     .wr(uart0_wr),
     .valid(uart0_valid),
     .busy(uart0_busy),
     .tx_data(dout[7:0]),
     .rx_data(uart0_data));

  // ######   LEDS & PIOS   ###################################

  reg [5:0] PIOS;
  wire CTS, RTS;
  assign {CTS, PIO1_20, PIO1_18, SPICLK, SPISI, SPISSB} = PIOS;
  reg [7:0] LEDS = 0;


  // ######   RING OSCILLATOR   ###############################

  wire [1:0] buffers_in, buffers_out;
  assign buffers_in = {buffers_out[0:0], ~buffers_out[1]};
  SB_LUT4 #(
          .LUT_INIT(16'd2)
  ) buffers [1:0] (
          .O(buffers_out),
          .I0(buffers_in),
          .I1(1'b0),
          .I2(1'b0),
          .I3(1'b0)
  );

  wire random = ~buffers_out[1];

  // ######   IO PORTS   ######################################

// READ REGISTERS
  assign io_din =

    ((mem_addr == `adr_porta_in) ?				porta_in	: 16'd0) |
    ((mem_addr == `adr_porta_out) ?				porta_out	: 16'd0) |
    ((mem_addr == `adr_porta_dir) ?				porta_dir	: 16'd0) |

    ((mem_addr == `adr_pios) ?					{ 2'd0, LEDS, PIOS}		: 16'd0) |

    ((mem_addr == `adr_uart0) ?					{ 8'd0, uart0_data}		: 16'd0) |
    ((mem_addr == `adr_util1) ? {10'd0, random, RTS, PIO1_19, SPISO, uart0_valid, !uart0_busy} : 16'd0) |

    ((mem_addr == `adr_tickssl) ?				tickss[15:0]	: 16'd0)|
    ((mem_addr == `adr_tickssh) ?				tickss[31:16]	: 16'd0)|
    ((mem_addr == `adr_ticksshh) ?				tickss[47:32]	: 16'd0) ;

  // Very few gates needed: Simply trigger warmboot by any IO access to $8000 / $8001 / $8002 / $8003.
  // SB_WARMBOOT _sb_warmboot ( .BOOT(io_wr & mem_addr[15]), .S1(mem_addr[1]), .S0(mem_addr[0]) );

// WRITE REGISTERS
  always @(posedge clk) begin

    if (io_wr & (mem_addr == `adr_porta_out))  porta_out <= dout;
    if (io_wr & (mem_addr == `adr_porta_dir))  porta_dir <= dout;    
    if (io_wr & (mem_addr == `adr_pios))       {LEDS, PIOS} <= dout[13:0];

  end

 
  // ######   MEMLOCK   #######################################

  // This is a workaround to protect memory contents during Reset.
  // Somehow it happens sometimes that the first memory location is corrupted during startup,
  // and as an IO write is one of the earliest things which are done, memory write access is unlocked
  // only after the processor is up and running and sending its welcome message.

  always @(negedge resetq or posedge clk)
  if (!resetq) unlocked <= 0;
  else         unlocked <= unlocked | io_wr;

endmodule // top
