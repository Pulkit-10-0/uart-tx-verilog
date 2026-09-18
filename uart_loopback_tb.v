`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.09.2026 17:58:39
// Design Name: 
// Module Name: uart_loopback_tb
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
module uart_loopback_tb;

    reg clk;
    reg reset;
    reg start;

    reg [7:0] data_in;

    wire [7:0] data_out;
    wire data_valid;

    wire tx;
    wire tx_busy;
    wire rx_busy;


    uart_loopback #(
        .CLK_FREQ(1_000_000),
        .BAUD_RATE(100_000)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),

        .data_out(data_out),
        .data_valid(data_valid),
        .tx(tx),
        .tx_busy(tx_busy),
        .rx_busy(rx_busy)
    );


    always #5 clk = ~clk;

  task send_byte(input [7:0] expected_data);
begin

    wait(tx_busy == 0);
    data_in = expected_data;

    #10;

    start = 1;

    #10;
    start = 0;

    wait(data_valid == 1);

    if (data_out == expected_data)
        $display("PASS: Expected = %h, Received = %h",
                 expected_data, data_out);
    else
        $display("FAIL: Expected = %h, Received = %h",
                 expected_data, data_out);

end
endtask

    initial begin
    
    clk     = 0;
    reset   = 1;
    start   = 0;
    data_in = 8'h00;

    #20;
    reset = 0;

    send_byte(8'hA5);
    send_byte(8'h3C);
    send_byte(8'hF0);
    send_byte(8'h55);

    #20;

    $finish;
    end

endmodule