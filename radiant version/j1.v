//`default_nettype none
// From Mecrisp-Ice repository
// IgorM: interrupt address change for 15kB ram
// IgorM 4-Feb-2018: added 8 interrupts with priority encoder and en/dis interrupt mask

module j1(
  input wire clk,
  input wire resetq,

  output wire io_rd,
  output wire io_wr,
  
  output wire [15:0] mem_addr,
  output wire mem_wr,
  
  output wire [15:0] dout,
  input  wire [15:0] io_din,

  output wire [12:0] code_addr,
  input  wire [15:0] insn_from_memory,
  
  input  wire [7:0] int_rqst    // 8 Interrupts, one-hot, msb the highest priority, lsb the lowest
);  

  reg [4:0] rsp, rspN;          // Return stack pointer
  reg [4:0] dsp, dspN;          // Data stack pointer
  reg [15:0] st0, st0N;         // Top of data stack
  reg dstkW;                    // Data stack write
  reg rstkW;                    // Return stack write
  wire [15:0] rstkD;            // Return stack write value
  reg [15:0] insn;  // was wire!!
  reg [13:0] pc, pcN;           // Program Counter
  
  reg interrupt_enable = 0;  
  wire interrupt_request = |( int_rqst );  // Any of the interrupts is active??
  wire interrupt = interrupt_request & interrupt_enable; // Mask it with Global interrupt enable
  
  always @* begin                // Interrupts - the Priority encoder
    casex (int_rqst)
      8'b1xxxxxxx : insn = interrupt ? 16'h5DFF : insn_from_memory;  // Interrupt: Execute "Call 3BFE"; Timer1
      8'b01xxxxxx : insn = interrupt ? 16'h5DFE : insn_from_memory;  // Interrupt: Execute "Call 3BFC";
      8'b001xxxxx : insn = interrupt ? 16'h5DFD : insn_from_memory;  // Interrupt: Execute "Call 3BFA";
      8'b0001xxxx : insn = interrupt ? 16'h5DFC : insn_from_memory;  // Interrupt: Execute "Call 3BF8";
      8'b00001xxx : insn = interrupt ? 16'h5DFB : insn_from_memory;  // Interrupt: Execute "Call 3BF6";
      8'b000001xx : insn = interrupt ? 16'h5DFA : insn_from_memory;  // Interrupt: Execute "Call 3BF4";
      8'b0000001x : insn = interrupt ? 16'h5DF9 : insn_from_memory;  // Interrupt: Execute "Call 3BF2";
      8'b00000001 : insn = interrupt ? 16'h5DF8 : insn_from_memory;  // Interrupt: Execute "Call 3BF0";
      default     : insn = insn_from_memory; 
    endcase
  end

  wire [13:0] pc_plus_1 = pc + {13'b0, ~interrupt};            // Do not increment PC for interrupts to continue later at the same location.
  wire fetch = pc[13] & ~interrupt;                            // Memory fetch data on pc[13] only valid if this is no interrupt entry.

  reg notreboot = 0;

  assign mem_addr = st0[15:0];
  assign code_addr = pcN;

  // The D and R stacks
  wire [15:0] st1, rst0;
  reg [1:0] dspI, rspI;

  stack2 #(.DEPTH(32)) rstack(.clk(clk), .rd(rst0), .we(rstkW), .wd(rstkD), .delta(rspI));
  stack2 #(.DEPTH(32)) dstack(.clk(clk), .rd(st1),  .we(dstkW), .wd(st0),   .delta(dspI));

  wire [16:0] minus = {1'b1, ~st0} + st1 + 1;
  
  wire signedless = st0[15] ^ st1[15] ? st1[15] : minus[16];
  wire unsignedless = minus[16];
  wire zeroflag = minus[15:0] == 0;

  // wire [31:0] umstar = 0;         // 43.51 MHz
  wire [31:0] umstar = st0 * st1;    // 36.00 MHz
  // wire [31:0] umstar = st1 * st0; // 34.53 MHz

  always @*
  begin
    // Compute the new value of st0
    casez ({fetch, insn[15:8]})

  //  9'b0_011_00000: st0N = st0;                                   // TOS
      9'b0_011_00001: st0N = st1;                                   // NOS
      9'b0_011_00010: st0N = st0 + st1;                             // +
      9'b0_011_00011: st0N = st0 & st1;                             // and

      9'b0_011_00100: st0N = st0 | st1;                             // or
      9'b0_011_00101: st0N = st0 ^ st1;                             // xor
      9'b0_011_00110: st0N = ~st0;                                  // invert
      9'b0_011_00111: st0N = {16{zeroflag}};                        //  =

      9'b0_011_01000: st0N = {16{signedless}};                      //  <
      9'b0_011_01001: st0N = {st0[15], st0[15:1]};                  // 1 arshift
      9'b0_011_01010: st0N = {st0[14:0], 1'b0};                     // 1 lshift
      9'b0_011_01011: st0N = rst0;                                  // r@

      9'b0_011_01100: st0N = minus[15:0];                           // -
      9'b0_011_01101: st0N = io_din;                                // Read IO
      9'b0_011_01110: st0N = {11'b0, dsp};                          // depth
      9'b0_011_01111: st0N = {16{unsignedless}};                    // u<


      9'b1_???_?????: st0N = insn;                                  // Memory fetch

      9'b0_1??_?????: st0N = { 1'b0, insn[14:0] };                  // Literal
  //  9'b0_000_?????: st0N = st0;                                   // Jump
  //  9'b0_010_?????: st0N = st0;                                   // Call
      9'b0_001_?????: st0N = st1;                                   // Conditional jump


  // Specials available on HX8K:

      9'b0_011_10000: st0N = st1 << st0;                            // lshift
      9'b0_011_10001: st0N = st1 >> st0;                            // rshift
      9'b0_011_10010: st0N = $signed(st1) >>> st0;                  // arshift
      9'b0_011_10011: st0N = {11'b0, rsp};                          // rdepth

      9'b0_011_10100: st0N = umstar[15:0];                          // Low  um*
      9'b0_011_10101: st0N = umstar[31:16];                         // High um*
      9'b0_011_10110: st0N = st0 + 1;                               // 1+
      9'b0_011_10111: st0N = st0 - 1;                               // 1-

      default: st0N = st0;
    endcase
  end

  wire func_T_N =   (insn[6:4] == 1);
  wire func_T_R =   (insn[6:4] == 2);
  wire func_write = (insn[6:4] == 3);
  wire func_iow =   (insn[6:4] == 4);
  wire func_ior =   (insn[6:4] == 5);
  wire func_dint =  (insn[6:4] == 6);
  wire func_eint =  (insn[6:4] == 7);

  wire is_alu = notreboot & !fetch & (insn[15:13] == 3'b011);

  assign mem_wr = is_alu & func_write;
  assign io_wr  = is_alu & func_iow;
  assign io_rd  = is_alu & func_ior;
  assign dout   = st1;

  wire eint = is_alu & func_eint;
  wire dint = is_alu & func_dint;

  wire interrupt_enableN = (interrupt_enable | eint) & ~(interrupt | dint);

  // Value which could be written to return stack: Either return address in case of a call or TOS.
  assign rstkD = (insn[13] == 1'b0) ? {1'b0, pc_plus_1, interrupt_enable} : st0;

  always @*
  begin
    casez ({fetch, insn[15:13]})                          // Calculate new data stack pointer
    4'b1_???,
    4'b0_1??:   {dstkW, dspI} = {1'b1,      2'b01};          // Memory Fetch & Literal
    4'b0_001:   {dstkW, dspI} = {1'b0,      2'b11};          // Conditional jump
    4'b0_011:   {dstkW, dspI} = {func_T_N,  {insn[1:0]}};    // ALU
    default:    {dstkW, dspI} = {1'b0,      2'b00};          // Default: Unchanged
    endcase
    dspN = dsp + {dspI[1], dspI[1], dspI[1], dspI};

    casez ({fetch, insn[15:13]})                          // Calculate new return stack pointer
    4'b1_???:   {rstkW, rspI} = {1'b0,      2'b11};          // Memory Fetch, triggered by high address bit set
    4'b0_010:   {rstkW, rspI} = {1'b1,      2'b01};          // Call
    4'b0_011:   {rstkW, rspI} = {func_T_R,  insn[3:2]};      // ALU
    default:    {rstkW, rspI} = {1'b0,      2'b00};          // Default: Unchanged
    endcase
    rspN = rsp + {rspI[1], rspI[1], rspI[1], rspI};

    casez ({notreboot, fetch, insn[15:13], insn[7], |st0})   // New address for PC
    7'b0_0_???_?_?:   pcN = 0;                               // Boot: Start at address zero
    7'b1_0_000_?_?,
    7'b1_0_010_?_?,
    7'b1_0_001_?_0:   pcN = {1'b0, insn[12:0]};              // Jumps & Calls: Destination address
    7'b1_1_???_?_?,
    7'b1_0_011_1_?:   pcN = rst0[14:1];                      // Memory Fetch & ALU+exit: Return
    default:          pcN = pc_plus_1;                       // Default: Increment PC to next opcode
    endcase
  end

  always @(negedge resetq or posedge clk)
  begin
    if (!resetq) begin
      notreboot <= 0;
      { pc, dsp, rsp, st0, interrupt_enable} <= 0;
    end else begin
      notreboot <= 1;
      { pc, dsp, rsp, st0, interrupt_enable} <= { pcN, dspN, rspN, st0N, interrupt_enableN };
    end
  end

endmodule
