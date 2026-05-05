`timescale 1ns / 1ps
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


module UART_RX_1frame(
    input RX,   //(ToDo) serial data input
    input BCLK, //(ToDo) receives clock, preferably 115200
    input EN,   //(ToDo) 0 => module disabled, 1 => module all healthy
    input parity_yes, //(ToDo) 0 => no parity bit, 1 => yes parity bit
    input stop_2b, //(ToDo) 0 => 1 stop bit, 1 => 2 stop bits
    output [7:0] FRAME_lower, //(ToDo) displays data from most recently received valid frame
    output NEW_FRAME, //(ToDo) switches to 1 and then to 0 when new data is on FRAME_lower
    output ERROR      //(ToDo) switches to 1 after invalid frame is receiver until a new start byte
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



endmodule
