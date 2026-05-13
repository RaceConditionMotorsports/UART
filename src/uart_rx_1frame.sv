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

always @ (negedge reset_n) begin
    error <= 1'b0;
    new_frame <= 1'b0;
    frame_out <= 8'b0;  
end



endmodule //UART_RX_1frame
