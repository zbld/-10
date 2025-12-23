`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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


module alu(
	input wire[31:0] a,b,
	input wire[3:0] op,  // Extended to 4-bit for sllv/srlv support
	output reg[31:0] y,
	output reg overflow,
	output wire zero
    );

	wire[31:0] s,bout;
	assign bout = op[2] ? ~b : b;
	assign s = a + bout + op[2];
	always @(*) begin
		case (op)
			4'b0000: y <= a & bout;         // AND
			4'b0001: y <= a | bout;         // OR
			4'b0010: y <= s;                // ADD
			4'b0011: y <= s[31];            // SLT
			4'b0100: y <= a & bout;         // AND (duplicate for compatibility)
			4'b0101: y <= a | bout;         // OR (duplicate for compatibility)
			4'b0110: y <= s;                // SUB
			4'b0111: y <= s[31];            // SLT (duplicate for compatibility)
			4'b1000: y <= b << a[4:0];      // SLLV - shift left logical variable
			4'b1001: y <= b >> a[4:0];      // SRLV - shift right logical variable
			default : y <= 32'b0;
		endcase	
	end
	assign zero = (y == 32'b0);

	always @(*) begin
		case (op[2:1])
			2'b01:overflow <= a[31] & b[31] & ~s[31] |
							~a[31] & ~b[31] & s[31];
			2'b11:overflow <= ~a[31] & b[31] & s[31] |
							a[31] & ~b[31] & ~s[31];
			default : overflow <= 1'b0;
		endcase	
	end
endmodule
