`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 20:51:21
// Design Name: 
// Module Name: uart_tx_tb
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

module uart_tx_tb;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] data_in;

    wire tx;
    wire busy;

    wire [9:0] baud_counter;
    wire [3:0] bit_counter;
    wire [7:0] shift_reg;
    wire baud_tick;

    uart_tx #(
        .CLK_FREQ(100),
        .BAUD_RATE(10)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .tx(tx),
        .busy(busy)
    );

    assign baud_counter = dut.baud_counter;
    assign bit_counter  = dut.bit_counter;
    assign shift_reg    = dut.shift_reg;
    assign baud_tick    = dut.baud_tick;


    always #5 clk = ~clk;

    initial begin
        clk = 0;
    end


    initial begin

        clk     = 0;
        reset   = 1;
        start   = 0;
        data_in = 8'b0;

        #20;

        reset = 0;

        data_in = 8'b10100101;
        start   = 1;

        #10;

        start = 0;

        #1200;

        $finish;

    end

endmodule
