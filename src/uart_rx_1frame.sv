`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RaceConditionMotorsports
// Engineer: Miko
// 
// Create Date: 05/05/2026 08:44:39 PM
// Design Name: 
// Module Name: UART_RX_1frame
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx_1frame(
    input logic clock, //(ToDo) receives clock, preferably 16x115200 = 18.432MHz
    input logic reset_n,  //(ToDo) receives clock 
    input logic rx,   //(ToDo) serial data input
    input logic en,   //(ToDo) 0 => module disabled, 1 => module all healthy
    input logic parity_yes, //(ToDo) 0 => no parity bit, 1 => yes parity bit
    input logic stop_2b, //(ToDo) 0 => 1 stop bit, 1 => 2 stop bits
    output logic [7:0] frame_out, //(ToDo) displays data from most recently received valid frame
    output logic new_frame, //(ToDo) switches to 1 and then to 0 when new data is on FRAME_lower
    output logic error      //(ToDo) switches to 1 after invalid frame is receiver until a new start byte
    );
    
//put your logic here

/**
* State machine for the frame receiver: possible states:
* 1. DISABLED
* 2. WAITING
* 3. READING_DATA
* 4. READING_PARITY
* 5. READING_STOP
*/
typedef enum { //one-hot enumeration (source: internet)
    DISABLED = 6'b000001,
    WAITING = 6'b000010,
    READING_DATA = 6'b000100,
    READING_PARITY = 6'b001000,
    READING_STOP = 6'b010000,
    ERROR  = 6'b100000
} possible_states;

possible_states current_state;
logic prev_rx, parity_bit;
logic [7:0] next_bit_timer, bits_received;

always @ (posedge clock or negedge reset_n) begin

if(!reset_n) begin
    error <= 1'b0;
    new_frame <= 1'b0;
    frame_out [7:0] <= 8'h0F;
    current_state <= WAITING;
    prev_rx = 1'b0;
    parity_bit = 1'b0;
    next_bit_timer = 8'hFF;
    bits_received = 8'd0;
end else if (!en) begin
    //do we even need enable if we have reset?
end else begin
    next_bit_timer = (next_bit_timer == 0) ? 0: next_bit_timer-1; //blocking because it is critical we decrement clock
    frame_out = (frame_out == 0) ? 0: frame_out-1; //DEBUG ONLY
    case (current_state)
        WAITING: begin
            if (prev_rx == 1 && rx == 1) begin
                //setup next_bit_timer_n to 1,5 clock cycle of the rx
                //change state to reading data
            end else begin
                //save rx as prev_rx
            end
        end
        READING_DATA: begin
            //if next_bit_timer_n is 00000:
            // 1. read data bit (bitshift frame_out? does that work?)
            // 2. set up next_bit_timer_n to 1 cc of the rx 
            // 3. increment bits received counter; if 8 bits received: state <= (parity) ? READING_PARITY: READING STOP;
            //else: decrement timer
        end
        READING_PARITY: begin
            // if next_bit_timer is 00000:
            // 1. set up next_bit_timer_n to 1 cc of the rx  
            // 2. read data bit; verify that parity is correct; throw error if necessary. (Thought: is it better to calculate parity with real time? it is just 1 bit after all)
            //else: decrement timer
        end
        READING_STOP: begin
            // if next_bit_timer is 00000:
            // 1. if bit is 0, go to error
            // 2. if bit is 1, set new_frame to 1 and set state to WAITING
            //else: decrement timer
        end
        ERROR: begin
            //nothing happens in error. We just lay dormant until the next reset.
        end
    endcase
end //if (!reset_n)
end //(posedge clock or negedge reset_n)

endmodule //UART_RX_1frame
