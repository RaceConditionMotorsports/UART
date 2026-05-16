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
    frame_out [7:0] <= 8'h0;
    current_state <= WAITING;
    prev_rx = 1'b0;
    parity_bit = 1'b0;
    next_bit_timer = 8'hFF;
    bits_received = 8'd0;
end else if (!en) begin
    //do we even need enable if we have reset?
end else begin
    case (current_state)
        WAITING: begin
            if (prev_rx == 1 && rx == 0) begin
                next_bit_timer <= 8'd24;//setup next_bit_timer_n to 1,5 clock cycle of the rx
                current_state <= READING_DATA;//change state to reading data
                prev_rx <= 1;
                new_frame = 1'b0; //blocking statment because we don't want to clear frame_out while still indicating it's valid.
                frame_out = 8'd0;
            end else begin
                prev_rx <= rx;//save rx as prev_rx
            end
        end
        READING_DATA: begin
            if (next_bit_timer == 0) begin //if next_bit_timer_n is 00000:
                frame_out = (frame_out << 1);// 1. push data bit to frame_out
                frame_out [0] = rx;
                next_bit_timer <= 8'd16;// 2. set up next_bit_timer_n to 1 cc of the rx 
                bits_received += 1;// 3. increment bits received counter;
                if (bits_received == 8) begin
                    current_state <= (parity_yes) ? READING_PARITY : READING_STOP;
                end
            end
            next_bit_timer = (next_bit_timer == 0) ? 0: next_bit_timer-1; //else: decrement timer
        end
        READING_PARITY: begin
            if (next_bit_timer == 0) begin
                next_bit_timer <= 8'd16;// 1. set up next_bit_timer_n to 1 cc of the rx  
                // 2. read data bit; verify that parity is correct; throw error if necessary. (Thought: is it better to calculate parity with real time? it is just 1 bit after all)            
                current_state <= READING_STOP; 
            end            
        end
        READING_STOP: begin
            if (next_bit_timer == 0) begin
                if (!rx) begin
                    current_state <= ERROR;// 1. if bit is 0, go to error
                end else begin
                    current_state <= WAITING;// 2. if bit is 1, set new_frame to 1 and set state to WAITING
                    new_frame <= 1'b1;
                end
            end
            next_bit_timer = (next_bit_timer == 0) ? 0: next_bit_timer-1;//else: decrement timer
        end
        ERROR: begin
            //nothing happens in error. We just lay dormant until the next reset.
        end
    endcase
end //if (!reset_n)
end //(posedge clock or negedge reset_n)

endmodule //UART_RX_1frame
