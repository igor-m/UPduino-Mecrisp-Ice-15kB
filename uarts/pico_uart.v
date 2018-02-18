/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */
 
// Modified by MatthiasK for Mecrisp-Ice, HX8

module simpleuart (
        input clk,
        input resetn,

        output ser_tx,
        input  ser_rx,

//      input   [3:0] reg_div_we,
//      input  [15:0] reg_div_di,
//      output [15:0] reg_div_do,

        input         reg_dat_we,
        input         reg_dat_re,
        input  [7:0] reg_dat_di,
        output [7:0] reg_dat_do,

        output        busy,
    output        valid
);

`define cfg_divider   417  // 48 MHz / 115200

//      reg [15:0] cfg_divider = 104;
// wire [15:0] cfg_divider = 417;

        reg [3:0] recv_state;
        reg [11:0] recv_divcnt;   // ** 15:0
        reg [7:0] recv_pattern;
        reg [7:0] recv_buf_data;
        reg recv_buf_valid;

        reg [9:0] send_pattern;
        reg [3:0] send_bitcnt;
        reg [11:0] send_divcnt;  // ** 15:0
        reg send_dummy;

//      assign reg_div_do = cfg_divider;

    assign reg_dat_do = recv_buf_data;
        assign busy = (send_bitcnt || send_dummy);
        assign valid = recv_buf_valid;

//      always @(posedge clk) begin
//              if (!resetn) begin
//                      cfg_divider <= 1;
//              end else begin
//                      if (reg_div_we[0]) cfg_divider[ 7: 0] <= reg_div_di[ 7: 0];
//                      if (reg_div_we[1]) cfg_divider[15: 8] <= reg_div_di[15: 8];
//                      if (reg_div_we[2]) cfg_divider[23:16] <= reg_div_di[23:16];
//                      if (reg_div_we[3]) cfg_divider[31:24] <= reg_div_di[31:24];
//              end
//      end

        always @(posedge clk) begin
                if (!resetn) begin
                        recv_state <= 0;
                        recv_divcnt <= 0;
                        recv_pattern <= 0;
                        recv_buf_data <= 0;
                        recv_buf_valid <= 0;
                end else begin
                        recv_divcnt <= recv_divcnt + 1;
                        if (reg_dat_re)
                                recv_buf_valid <= 0;
                        case (recv_state)
                                0: begin
                                        if (!ser_rx)
                                                recv_state <= 1;
                                        recv_divcnt <= 0;
                                end
                                1: begin
                                        if (2*recv_divcnt > `cfg_divider) begin
                                                recv_state <= 2;
                                                recv_divcnt <= 0;
                                        end
                                end
                                10: begin
                                        if (recv_divcnt > `cfg_divider) begin
                                                recv_buf_data <= recv_pattern;
                                                recv_buf_valid <= 1;
                                                recv_state <= 0;
                                        end
                                end
                                default: begin
                                        if (recv_divcnt > `cfg_divider) begin
                                                recv_pattern <= {ser_rx, recv_pattern[7:1]};
                                                recv_state <= recv_state + 1;
                                                recv_divcnt <= 0;
                                        end
                                end
                        endcase
                end
        end

        assign ser_tx = send_pattern[0];

        always @(posedge clk) begin
//              if (reg_div_we)
//                      send_dummy <= 1;
                send_divcnt <= send_divcnt + 1;
                if (!resetn) begin
                        send_pattern <= ~0;
                        send_bitcnt <= 0;
                        send_divcnt <= 0;
                        send_dummy <= 1;
                end else begin
                        if (send_dummy && !send_bitcnt) begin
                                send_pattern <= ~0;
                                send_bitcnt <= 15;
                                send_divcnt <= 0;
                                send_dummy <= 0;
                        end else
                        if (reg_dat_we && !send_bitcnt) begin
                                send_pattern <= {1'b1, reg_dat_di[7:0], 1'b0};
                                send_bitcnt <= 10;
                                send_divcnt <= 0;
                        end else
                        if (send_divcnt > `cfg_divider && send_bitcnt) begin
                                send_pattern <= {1'b1, send_pattern[9:1]};
                                send_bitcnt <= send_bitcnt - 1;
                                send_divcnt <= 0;
                        end
                end
        end
endmodule


module buart(
   input wire clk,
   input wire resetq,
   input wire rx,           // recv wire
   output wire tx,          // xmit wire
   input wire rd,           // read strobe
   input wire wr,           // write strobe
   output wire valid,       // has recv data
   output wire busy,        // is transmitting
   input wire [7:0] tx_data,
   output wire [7:0] rx_data // data
);

  simpleuart _simpleuart (
     .clk(clk),
     .resetn(resetq),

     .ser_rx(rx),
     .ser_tx(tx),

     .reg_dat_we(wr),
     .reg_dat_re(rd),
     .reg_dat_di(tx_data),
     .reg_dat_do(rx_data),

     .busy(busy),
     .valid(valid)
   );

endmodule