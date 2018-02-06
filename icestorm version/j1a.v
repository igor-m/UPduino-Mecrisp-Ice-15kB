`timescale 1 ns / 1 ps

//`default_nettype none
`define WIDTH 16

// Modifications for 15kB block ram, and various other modifications
// by IgorM 11-Dec-2017
// Mind the SPI Flash on the UPduino board must be wired as below
// IgorM 13-Jan-2018: removed obsolate HW 
// IgorM 4-Feb-2018: Added 8 interrupts with priority encoder and interrupt's en/dis mask

module SB_RAM256x16(
    output wire [15:0] RDATA,
    input  wire RCLK, RCLKE, RE,
    input  wire [7:0] RADDR,
    input  wire WCLK, WCLKE, WE,
    input  wire [7:0] WADDR,
    input  wire [15:0] MASK, WDATA
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
    .MASK(16'h0000), 
    .WDATA(WDATA) );

  assign RDATA = rd;

endmodule


// @@@@@@@@@@@@@@@@@@@@@@@@@@

module SB_RAM2048x2(
    output wire [1:0] RDATA,
    input  wire RCLK, RCLKE, RE,
    input  wire [10:0] RADDR,
    input  wire WCLK, WCLKE, WE,
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
    .MASK(16'h0000), 
    .WDATA({4'b0, WDATA[1], 7'b0, WDATA[0], 3'b0}));

  assign RDATA[0] = rd[3];
  assign RDATA[1] = rd[11];

endmodule

module top(

        input wire oscillator,

        output wire TXD,       // UART TX
        input  wire RXD,       // UART RX

        output wire SPICLK,    // Flash SCK  --- fpga spiclk  pin 15
        input  wire SPISO,     // Flash SDO  --- fpga spisi   pin 17
        output wire SPISI,     // Flash SDI  --- fpga spiso   pin 14
        output wire SPISSB,    // Flash CS   --- fpga spissb  pin 16

        output wire PIO1_18,   // IR TXD
        input  wire PIO1_19,   // IR RXD
        output wire PIO1_20,   // IR SD

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

        output wire RGB0,
        output wire RGB1,
        output wire RGB2,
 
        input wire resetq,

        input wire INTR0,
        input wire INTR1,
        input wire INTR2,
        input wire INTR3
);

  // ######   CPU CLOCKS   ###################################

   wire clk ;
  
   // ### Option 1: External 30MHz oscillator (3.3V level)
  
   assign clk = oscillator;

   // ### Option 2: Internal PLL based (max 30MHz with IceCube2)
  
   // my_pll my_pll_inst( 
   //                   .REFERENCECLK(oscillator),
   //                   .PLLOUTCORE(clk),
   //                   .PLLOUTGLOBAL(),
   //                   .RESET(1'b1)   );
 
   // ### Option 3: Internal 24MHz (48MHz/2) oscillator
 
   // SB_HFOSC OSCInst0(
   //                  .CLKHFEN(1'b1),
   //                  .CLKHFPU(1'b1),
   //                  .CLKHF(clk)   );
   // defparam OSCInst0.CLKHF_DIV = "0b01";  // 48MHz DIVIDED by 2

  // ######   RAM   ###########################################
  
  wire io_rd, io_wr;
  wire [15:0] mem_addr;
  wire mem_wr;
  wire [15:0] dout;
  wire [15:0] io_din;
  wire [12:0] code_addr;

  reg unlocked = 0;

`include "../ram/ram_test.v"


  // ######   j1a CPU   ########################################
  
    reg [7:0] interrupt = 0;       // up to 8 Interrupts pending, one-hot, the bit 7 is the highest priority interrupt
    reg [7:0] int_mask  = 0;       // intr enable mask - 1 means the x-th interrupt is enabled
    reg [7:0] int_flags = 8'hFF;   // flags for clearing the processed pending interrupts (off the ISRs)

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
    .int_rqst( (interrupt & int_mask) )
  );
  

  // ######   DEFINES for IOs and PERIPHERALs   #################

`define adr_int_flgs        16'd40   // 
`define adr_int_mask        16'd50   // 

`define adr_ticksl          16'd100  // 
`define adr_ticksh          16'd101  // 
`define adr_tickshh         16'd102  // 

`define adr_tickssl         16'd105  // 
`define adr_tickssh         16'd106  // 
`define adr_ticksshh        16'd107  // 
`define adr_ticksample      16'd109  // 

`define adr_timer1cl        16'd110  // 
`define adr_timer1ch        16'd111  // 

`define adr_uart0           16'h1000 // 16'h1000

`define adr_porta_in        16'd310  // 
`define adr_porta_out       16'd311  // 
`define adr_porta_dir       16'd312  // 
 
`define adr_pios            16'h8    // 16'h8

`define adr_util1           16'h2000 // 16'h2000


  // ######   INT_0  RISING EDGE  ################################
  
  reg int0_1, int0_2, int0_3;
  wire int0re;
  
  // Input pin 3FF synchronizer
  
    always @(posedge clk)
    begin
        int0_1 <= INTR0;
        int0_2 <= int0_1;
        int0_3 <= int0_2;
    end
 
    assign int0re =  int0_2 & (~int0_3);
 
    always @(posedge clk)
    if (int0re == 1)
        interrupts[0] <= 1;
    else
        interrupts[0] <= interrupts[0] & int_flags[0];


  // ######   INT_1  RISING EDGE  ################################
  
  reg int1_1, int1_2, int1_3;
  wire int1re;
  
  // Input pin 3FF synchronizer
  
    always @(posedge clk)
    begin
        int1_1 <= INTR1;
        int1_2 <= int1_1;
        int1_3 <= int1_2;
    end
 
    assign int1re =  int1_2 & (~int1_3);
 
    always @(posedge clk)
    if (int1re == 1)
        interrupts[1] <= 1;
    else
        interrupts[1] <= interrupts[1] & int_flags[1];


  // ######   INT_2  RISING EDGE  #################################
  
  reg int2_1, int2_2, int2_3;
  wire int2re;
  
  // Input pin 3FF synchronizer
  
    always @(posedge clk)
    begin
        int2_1 <= INTR2;
        int2_2 <= int2_1;
        int2_3 <= int2_2;
    end
 
    assign int2re =  int2_2 & (~int2_3);
 
    always @(posedge clk)
    if (int2re == 1)
        interrupts[2] <= 1;
    else
        interrupts[2] <= interrupts[2] & int_flags[2];


  // ######   INT_3  RISING EDGE  #################################
  
  reg int3_1, int3_2, int3_3;
  wire int3re;
  
  // Input pin 3FF synchronizer
  
    always @(posedge clk)
    begin
        int3_1 <= INTR3;
        int3_2 <= int3_1;
        int3_3 <= int3_2;
    end
    
    assign int3re = int3_2 & (~int3_3);
 
    always @(posedge clk)
    if (int3re == 1)
        interrupts[3] <= 1;
    else
        interrupts[3] <= interrupts[3] & int_flags[3];


  // ######   48 bit CPU TICKS   ##################################

  reg  [47:0] ticks = 0;
  reg  [47:0] tickss = 0;

  // timer ticks

  wire [47:0] ticks_plus_1 = ticks + 1;

  always @(posedge clk)
     ticks <= ticks_plus_1;

  // sample the ticks with "now"

  always @(posedge clk)
     if (io_wr & (mem_addr == `adr_ticksample))  tickss[47:0] <= ticks;


  // ###########  Periodic Timer1 (millis) INTERRUPT 7  ########

  reg [31:0] timer1 = 0;
  reg [31:0] timer1c = 0;

  wire [31:0] timer1_minus_1 = timer1 - 1;

  always @(posedge clk)
    if ( (io_wr & (mem_addr == `adr_timer1ch)) || ( interrupt[7] == 1 ) )
        timer1[31:0] <= timer1c[31:0];
    else
        timer1 <= timer1_minus_1;

  always @(posedge clk)                               // Generate interrupt INT_7 on timer1 compare
    if (timer1 == 1) 
        interrupt[7] <= 1;                            // Set the interrupt INT_7
    else
                                                      // Example of clearing the interrupt pending flag:
        interrupt[7] <= interrupt[7] & int_flags[7];  // Clear the pending interrupt (off the ISR)
        

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

  // an RxD 3FF input synchroniser

  reg rxd1, rxd2, rxd3;
  always @(posedge clk)
    begin
    rxd1 <= RXD;
    rxd2 <= rxd1;
    rxd3 <= rxd2;
    end 

  wire uart0_valid, uart0_busy;
  wire [7:0] uart0_data;
  wire uart0_wr = io_wr & (mem_addr == `adr_uart0);
  wire uart0_rd = io_rd & (mem_addr == `adr_uart0);
  wire UART0_RX;
  buart _uart0 (
     .clk(clk),
     .resetq(1'b1),
     .rx(rxd3),
     .tx(TXD),
     .rd(uart0_rd),
     .wr(uart0_wr),
     .valid(uart0_valid),
     .busy(uart0_busy),
     .tx_data(dout[7:0]),
     .rx_data(uart0_data));

  // ######  PIOS   ###################################

  reg [4:0] PIOS;
  assign {PIO1_20, PIO1_18, SPICLK, SPISI, SPISSB} = PIOS;
 
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

 // READ THE IO REGISTERS
 
  assign io_din =
  
    ((mem_addr == `adr_int_flgs)    ?   int_flags           : 16'd0) |
    ((mem_addr == `adr_int_mask)    ?   int_mask            : 16'd0) |
    
    ((mem_addr == `adr_porta_in)    ?   porta_in            : 16'd0) |
    ((mem_addr == `adr_porta_out)   ?   porta_out           : 16'd0) |
    ((mem_addr == `adr_porta_dir)   ?   porta_dir           : 16'd0) |

    ((mem_addr == `adr_pios)        ?   { 11'd0, PIOS}      : 16'd0) |

    ((mem_addr == `adr_uart0)       ?   { 8'd0, uart0_data} : 16'd0) |
    ((mem_addr == `adr_util1)       ?   {10'd0, random, 1'b1, PIO1_19, SPISO, uart0_valid, !uart0_busy} : 16'd0) |

    ((mem_addr == `adr_tickssl)     ?   tickss[15:0]        : 16'd0)|
    ((mem_addr == `adr_tickssh)     ?   tickss[31:16]       : 16'd0)|
    ((mem_addr == `adr_ticksshh)    ?   tickss[47:32]       : 16'd0) ;


 // WRITE THE IO REGISTERS
 
  always @(posedge clk) begin
  
    if (io_wr & (mem_addr == `adr_int_flgs))  int_flags <= dout;
    if (io_wr & (mem_addr == `adr_int_mask))   int_mask <= dout;

    if (io_wr & (mem_addr == `adr_porta_out))  porta_out <= dout;
    if (io_wr & (mem_addr == `adr_porta_dir))  porta_dir <= dout;
    
    if (io_wr & (mem_addr == `adr_pios))       {PIOS} <= dout[4:0];

    if (io_wr & (mem_addr == `adr_timer1cl))   timer1c[15:0] <= dout;
    if (io_wr & (mem_addr == `adr_timer1ch))   timer1c[31:16] <= dout;

  end

 
  // ######   MEMLOCK   ########################################

  // This is a workaround to protect memory contents during Reset.
  // Somehow it happens sometimes that the first memory location is corrupted during startup,
  // and as an IO write is one of the earliest things which are done, memory write access is unlocked
  // only after the processor is up and running and sending its welcome message.

  always @(negedge resetq or posedge clk)
  if (!resetq) unlocked <= 0;
  else         unlocked <= unlocked | io_wr;
  
  
  // ######   RGB Tx/Rx indicator   ############################

  defparam RGBA_DRIVER.CURRENT_MODE = "0b1";

  defparam RGBA_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGBA_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGBA_DRIVER.RGB2_CURRENT = "0b000001";

    SB_RGBA_DRV RGBA_DRIVER (
        .CURREN(1'b1),
        .RGBLEDEN(1'b1),
        .RGB0PWM(~TXD),
        .RGB1PWM(~RXD),
        .RGB2PWM(0),
        .RGB0(RGB0),
        .RGB1(RGB1),
        .RGB2(RGB2)
    );

endmodule // top
