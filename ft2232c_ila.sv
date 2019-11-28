`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2019 14:11:47
// Design Name: 
// Module Name: ft2232c_ila
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

`default_nettype none

module ft2232c_ila(
input wire CLK100MHZ,
input wire UART_TXD_IN,
output reg UART_RXD_OUT,
output reg UART_CTS,
input wire UART_RTS,
input wire BT_MISO,
output reg BT_MOSI,
output reg BT_SCK,
output reg BT_CS
    );

reg spi_csn_cnt1, spi_csn_cnt2;
wire spi_csn = spi_csn_cnt1 & spi_csn_cnt2;
wire spi_clk = spi_csn ? UART_TXD_IN & UART_RTS : UART_TXD_IN;
wire spi_mosi = spi_csn ? 1'b0 : UART_RTS;

always @(posedge CLK100MHZ)
  begin
    BT_MOSI <= spi_mosi;
    BT_SCK <= spi_clk;
    BT_CS <= spi_csn;
    UART_RXD_OUT <= BT_MISO;
    UART_CTS <= BT_MISO;
 end

ila_0 instance_name (
        .clk(CLK100MHZ), // input wire clk
        .probe0(UART_TXD_IN), // input wire [0:0]  probe0  
        .probe1(UART_RXD_OUT), // input wire [0:0]  probe1 
        .probe2(UART_CTS), // input wire [0:0]  probe2 
        .probe3(UART_RTS), // input wire [0:0]  probe3
        .probe4({spi_csn_cnt1,spi_csn_cnt2}),
        .probe5(spi_mosi),
        .probe6(spi_csn),
        .probe7(spi_clk)
    );

always @(posedge UART_RTS or negedge UART_TXD_IN)
            if (!UART_TXD_IN)
            begin
                spi_csn_cnt1 <= 1'b0;
            end
            else
                begin
                spi_csn_cnt1 <= 1'b1;
                end
                
always @(negedge UART_RTS or negedge UART_TXD_IN)
                        if (!UART_TXD_IN)
                        begin
                            spi_csn_cnt2 <= 1'b0;
                        end
                        else
                            begin
                            spi_csn_cnt2 <= 1'b1;
                            end

endmodule
