`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2026 19:04:18
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input reset,
    input rx,

    output reg [7:0] data_out,
    output reg data_valid,
    output busy
);

    parameter CLK_FREQ  = 100_000_000;
    parameter BAUD_RATE = 115200;

    localparam BAUD_COUNT      = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD_COUNT = BAUD_COUNT / 2;

  
    reg [15:0] baud_counter;
    reg [3:0]  bit_counter;
    reg [7:0]  shift_reg;
    reg [1:0] state;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;



    always @(posedge clk) begin

        if (reset) begin

            baud_counter <= 0;
            bit_counter  <= 0;
            shift_reg    <= 0;
            data_out     <= 0;
            data_valid   <= 0;
            state        <= IDLE;

        end

        else begin

            data_valid <= 0;

            case (state)
            
                IDLE: begin

                    baud_counter <= 0;
                    bit_counter  <= 0;


                    if (rx == 1'b0) begin

                        state <= START;

                        baud_counter <= 0;

                    end

                end


                START: begin

        
                    if (baud_counter == HALF_BAUD_COUNT - 1) begin

                        baud_counter <= 0;
                        if (rx == 1'b0) begin

                            state       <= DATA;
                            bit_counter <= 0;

                        end
                        else begin
                            state <= IDLE;

                        end

                    end
                    else begin

                        baud_counter <= baud_counter + 1;

                    end

                end


                DATA: begin

                    // Wait one complete bit period
                    if (baud_counter == BAUD_COUNT - 1) begin

                        baud_counter <= 0;

                  
                   
                        shift_reg <= {rx, shift_reg[7:1]};

                        if (bit_counter == 7) begin
                            state <= STOP;

                        end
                        else begin

                            bit_counter <= bit_counter + 1;

                        end

                    end
                    else begin

                        baud_counter <= baud_counter + 1;

                    end

                end

                STOP: begin

           
                    if (baud_counter == BAUD_COUNT - 1) begin

                        baud_counter <= 0;

                        if (rx == 1'b1) begin

                            data_out   <= shift_reg;
                            data_valid <= 1'b1;

                        end

                        state <= IDLE;

                    end
                    else begin

                        baud_counter <= baud_counter + 1;

                    end

                end


                default: begin

                    state        <= IDLE;
                    baud_counter <= 0;
                    bit_counter  <= 0;
                    shift_reg    <= 0;

                end

            endcase

        end

    end



    assign busy = (state != IDLE);

endmodule