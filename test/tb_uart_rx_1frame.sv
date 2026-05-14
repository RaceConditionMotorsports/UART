`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2026 09:27:33 PM
// Design Name: 
// Module Name: tb_UART_RX_1frame
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


module tb_UART_RX_1frame();

logic clock, reset_n, rx, enable, parity_yes, stop_2b, new_frame, error;
logic [7:0] frame;

/**
* Device under test - UART_RX_1frame
*/
uart_rx_1frame dut(
    .reset_n (reset_n),
    .clock (clock),
    .rx (RX),
    .en (enable),
    .parity_yes (parity_yes),
    .stop_2b (stop_2b),
    .frame_out (frame),
    .new_frame (new_frame),
    .error (error)
);

//initialisation
initial begin
   clock <= 0;
   reset_n <= 1;
   #1000
   $finish;
end
    
//simulation
always begin //driving clock
    #5
    clock = ~clock;
end

always begin //driving reset
    #200 
    reset_n = ~reset_n;
end

endmodule
