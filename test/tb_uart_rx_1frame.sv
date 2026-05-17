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
    .clock (clock),
    .reset_n (reset_n),
    .rx (rx),
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
   enable <= 1;
   rx <=0;
   parity_yes <= 1;
   stop_2b <= 0;
   #5000
   $finish;
end
    
//simulation
always begin //driving clock
    #1
    clock = ~clock;
end

always begin //driving reset and parity bit
    #10 
    reset_n = 1'b0;
    #80
    reset_n = 1'b1;
    parity_yes = ~parity_yes;
    #1000;
    #10 
    reset_n = 1'b0;
    #80
    reset_n = 1'b1;
    parity_yes = ~parity_yes;
    stop_2b = ~stop_2b;
    #1000;
end

always begin //driving rx
    #96
    rx = 1;
    #32
    rx = 0; //start of frame: 
    #32
    for (int i = 0; i < 8; i++) begin //data bits
        rx = ~rx; //Find a trick to write 8-bit sequence with 1 line
        #32;   
    end
    rx = 0; //parity
    #32
    rx = 1; //stop bit
    #32;
end

endmodule

//Create a task: send UART Message with parity and 1 stop bit
task frame_tx_p1_s1(
    output tx);
    tx = 1;
    #32
    tx = 0; //start of frame
    #32
    for (int i = 0; i < 8; i++) begin //data bits
        tx = ~tx; //Find a trick to write 8-bit sequence with 1 line
        #32;   
    end
    tx = 0; //parity
    #32
    tx = 1; //stop bit
    #32;
endtask
//Create a task: send UART Message with parity and 2 stop bits

//Create a task: send UART Message with no parity and 1 stop bit

//Create a task: send UART Message with no parity and 2 stop bits

