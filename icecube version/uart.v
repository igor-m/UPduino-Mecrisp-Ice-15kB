// Documented Verilog UART
// Copyright (C) 2010 Timothy Goddard (tim@goddard.net.nz)
// Distributed under the MIT licence.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
// 
// Modification of interface for swapforth j1a use by Bernard Mentink 2016.
module buart(
    input wire  clk, // The master clock for this module
    input wire resetq, // Synchronous reset, active low
    input wire rx, // Incoming serial line
    output wire tx, // Outgoing serial line
    input wire rd, // read strobe 
    input wire wr, // write strobe   
    output wire valid, // Indicated that a byte has been received.
    output wire busy, // Low when transmit line is idle.
    input wire [7:0] tx_data, // Byte to transmit
    output wire [7:0] rx_data // Byte received
    );

`define CLKFREQ   30000000    // frequency of incoming signal 'clk'
`define BAUD      115200
 
localparam CLOCK_DIVIDE = `CLKFREQ / (`BAUD * 4);
 
// States for the receiving state machine.
// These are just constants, not parameters to override.
parameter RX_IDLE = 0;
parameter RX_CHECK_START = 1;
parameter RX_READ_BITS = 2;
parameter RX_CHECK_STOP = 3;
parameter RX_DELAY_RESTART = 4;
parameter RX_ERROR = 5;
parameter RX_RECEIVED = 6;
 
// States for the transmitting state machine.
// Constants - do not override.
parameter TX_IDLE = 0;
parameter TX_SENDING = 1;
parameter TX_DELAY_RESTART = 2;
 
reg [10:0] rx_clk_divider = CLOCK_DIVIDE;
reg [10:0] tx_clk_divider = CLOCK_DIVIDE;
 
reg [2:0] recv_state = RX_IDLE;
reg [5:0] rx_countdown;
reg [3:0] rx_bits_remaining;
reg [7:0] rx_data_;
 
reg tx_out = 1'b1;
reg [1:0] tx_state = TX_IDLE;
reg [5:0] tx_countdown;
reg [3:0] tx_bits_remaining;
reg [7:0] tx_data_;
 
assign valid = recv_state == RX_RECEIVED;
assign rx_data = rx_data_;
 
assign tx = tx_out;
assign busy = tx_state != TX_IDLE;
 
always @(posedge clk) begin
  if (!resetq) begin
		recv_state = RX_IDLE;
		tx_state = TX_IDLE;
	end
  
 
	// The clk_divider counter counts down from
	// the CLOCK_DIVIDE constant. Whenever it
	// reaches 0, 1/16 of the bit period has elapsed.
        // Countdown timers for the receiving and transmitting
	// state machines are decremented.
	rx_clk_divider = rx_clk_divider - 1;
	if (!rx_clk_divider) begin
		rx_clk_divider = CLOCK_DIVIDE;
		rx_countdown = rx_countdown - 1;
	end
	tx_clk_divider = tx_clk_divider - 1;
	if (!tx_clk_divider) begin
		tx_clk_divider = CLOCK_DIVIDE;
		tx_countdown = tx_countdown - 1;
	end
 
	// Receive state machine
	case (recv_state)
		RX_IDLE: begin
			// A low pulse on the receive line indicates the
			// start of data.
			if (!rx) begin
				// Wait half the period - should resume in the
				// middle of this first pulse.
				rx_clk_divider = CLOCK_DIVIDE;
				rx_countdown = 2;
				recv_state = RX_CHECK_START;
			end
		end
		RX_CHECK_START: begin
			if (!rx_countdown) begin
				// Check the pulse is still there
				if (!rx) begin
					// Pulse still there - good
					// Wait the bit period to resume half-way
					// through the first bit.
					rx_countdown = 4;
					rx_bits_remaining = 8;
					recv_state = RX_READ_BITS;
				end else begin
					// Pulse lasted less than half the period -
					// not a valid transmission.
					recv_state = RX_ERROR;
				end
			end
		end
		RX_READ_BITS: begin
			if (!rx_countdown) begin
				// Should be half-way through a bit pulse here.
				// Read this bit in, wait for the next if we
				// have more to get.
                rx_data_ = {rx, rx_data_[7:1]};
				rx_countdown = 4;
				rx_bits_remaining = rx_bits_remaining - 1;
				recv_state = rx_bits_remaining ? RX_READ_BITS : RX_CHECK_STOP;
			end
		end
		RX_CHECK_STOP: begin
			if (!rx_countdown) begin
				// Should resume half-way through the stop bit
				// This should be high - if not, reject the
				// transmission and signal an error.
				recv_state = rx ? RX_RECEIVED : RX_ERROR;
			end
		end
		RX_DELAY_RESTART: begin
			// Waits a set number of cycles before accepting
			// another transmission.
			recv_state = rx_countdown ? RX_DELAY_RESTART : RX_IDLE;
		end
		RX_ERROR: begin
			// There was an error receiving.
			// Raises the recv_error flag for one clock
			// cycle while in this state and then waits
			// 2 bit periods before accepting another
			// transmission.
			rx_countdown = 8;
			recv_state = RX_DELAY_RESTART;
		end
		RX_RECEIVED: begin
			// Successfully received a byte.
			// Raises the received flag for one clock
			// cycle while in this state.
                    if(rd) begin
			recv_state = RX_IDLE;
                    end
		end
	endcase
 
	// Transmit state machine
	case (tx_state)
		TX_IDLE: begin
                    if (wr) begin
				// If the transmit flag is raised in the idle
				// state, start transmitting the current content
				// of the tx_byte input.
				tx_data_ = tx_data;
				// Send the initial, low pulse of 1 bit period
				// to signal the start, followed by the data
				tx_clk_divider = CLOCK_DIVIDE;
				tx_countdown = 4;
				tx_out = 0;
				tx_bits_remaining = 8;
				tx_state = TX_SENDING;
                    end
		end
		TX_SENDING: begin
			if (!tx_countdown) begin
				if (tx_bits_remaining) begin
					tx_bits_remaining = tx_bits_remaining - 1;
					tx_out = tx_data_[0];
                  tx_data_ = {1'b0, tx_data_[7:1]};
					tx_countdown = 4;
					tx_state = TX_SENDING;
				end else begin
					// Set delay to send out 2 stop bits.
					tx_out = 1;
					tx_countdown = 8;
					tx_state = TX_DELAY_RESTART;
				end
			end
		end
		TX_DELAY_RESTART: begin
			// Wait until tx_countdown reaches the end before
			// we send another transmission. This covers the
			// "stop bit" delay.
			tx_state = tx_countdown ? TX_DELAY_RESTART : TX_IDLE;
		end
	endcase
end
 
endmodule