`timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 14.09.2026 16:57:53
    // Design Name: 
    // Module Name: uart_loopback
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
    
   `timescale 1ns / 1ps

module uart_loopback #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output [7:0] data_out,
    output data_valid,
    output tx,
    output tx_busy,
    output rx_busy
);

    wire serial_line;

    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) tx_inst(
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),
        .busy(tx_busy),
        .tx(serial_line)
    );

    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) rx_inst(
        .clk(clk),
        .reset(reset),
        .rx(serial_line),
        .data_out(data_out),
        .busy(rx_busy),
        .data_valid(data_valid)
    );

    assign tx = serial_line;

endmodule
