`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2026 19:04:43
// Design Name: 
// Module Name: uart_rx_tb
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

module uart_rx_tb;

    reg clk;
    reg reset;
    reg rx;

    wire [7:0] data_out;
    wire data_valid;
    wire busy;


    uart_rx dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(data_out),
        .data_valid(data_valid),
        .busy(busy)
    );

    
    always #5 clk = ~clk;

   
    initial begin

        clk   = 0;
        reset = 1;
        rx    = 1;

        #20;

        reset = 0;



        rx = 0;
        #100;


      
        rx = 1;
        #100;

       
        rx = 0;
        #100;

    
        rx = 1;
        #100;

      
        rx = 0;
        #100;


        rx = 0;
        #100;

        rx = 1;
        #100;

        rx = 0;
        #100;

       
        rx = 1;
        #100;


        rx = 1;
        #100;


       
        rx = 1;

        #100;


        $finish;

    end

endmodule