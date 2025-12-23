`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/14 19:49:17
// Design Name: 
// Module Name: pc
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


module pc(
    input  wire       clk,
    input  wire       rst,
    input  wire [31:0] pcnext,
    output reg  [31:0] pc
    );
    always @(negedge clk or posedge rst) begin
        if (rst) pc <= 32'b0;
        else     pc <= pcnext;
    end
endmodule
