`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 19:08:58
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg tx,
    output busy
);
    
    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 115200;
    localparam BAUD_COUNT = CLK_FREQ / BAUD_RATE;
    
    reg [9:0] baud_counter;
    reg [3:0] bit_counter;
    reg [7:0] shift_reg;
    reg baud_tick;

    reg [1:0] state;
    reg [1:0] next_state;
    
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
    always @(posedge clk) begin
    if (reset) begin
        baud_counter <= 0;
        baud_tick    <= 0;
        state        <= IDLE;
    end
    else begin

        state <= next_state;

        if (state == IDLE && start) begin
            baud_counter <= 0;
            baud_tick    <= 0;
        end

        else if (baud_counter == BAUD_COUNT - 1) begin
            baud_counter <= 0;
            baud_tick    <= 1;
        end

        else begin
            baud_counter <= baud_counter + 1;
            baud_tick    <= 0;
        end

    end
end
 

    


always @(*) begin
    case (state)

        IDLE: begin
            if (start)
                next_state = START;
            else
                next_state = IDLE;
        end

        START: begin
            if (baud_tick)
                next_state = DATA;
            else
                next_state = START;
        end

        DATA: begin
            if (baud_tick && bit_counter == 7)
                next_state = STOP;
            else
                next_state = DATA;
        end

        STOP: begin
            if (baud_tick)
                next_state = IDLE;
            else
                next_state = STOP;
        end

        default:
            next_state = IDLE;

    endcase
end
 
always @(posedge clk) begin
    if (reset) begin
        bit_counter <= 0;
        shift_reg   <= 0;
    end
    else begin

        if (state == IDLE && start) begin
            shift_reg   <= data_in;
            bit_counter <= 0;
        end

        else if (state == DATA && baud_tick) begin
            shift_reg   <= shift_reg >> 1;
            bit_counter <= bit_counter + 1;
        end

    end
end
 
 
always @(*) begin

    case (state)

        IDLE:
            tx = 1'b1;

        START:
            tx = 1'b0;

        DATA:
            tx = shift_reg[0];

        STOP:
            tx = 1'b1;

        default:
            tx = 1'b1;

    endcase

end

assign busy = (state != IDLE); 

endmodule