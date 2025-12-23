`timescale 1ns / 1ps
module maindec(
    input  wire [5:0] op,
    output reg        memtoreg,
    output reg        memwrite,
    output reg        branch,
    output reg        alusrc,
    output reg        regdst,
    output reg        regwrite,
    output reg        jump,
    output reg [1:0]  aluop
);
    always @(*) begin
        case (op)
            6'b000000: begin // R-type
                memtoreg = 0; memwrite = 0;
                branch   = 0; alusrc   = 0;
                regdst   = 1; regwrite = 1;
                jump     = 0; aluop    = 2'b10;
            end
            6'b100011: begin // lw
                memtoreg = 1; memwrite = 0;
                branch   = 0; alusrc   = 1;
                regdst   = 0; regwrite = 1;
                jump     = 0; aluop    = 2'b00;
            end
            6'b101011: begin // sw
                memtoreg = 0; memwrite = 1;
                branch   = 0; alusrc   = 1;
                regdst   = 0; regwrite = 0;
                jump     = 0; aluop    = 2'b00;
            end
            6'b000100: begin // beq
                memtoreg = 0; memwrite = 0;
                branch   = 1; alusrc   = 0;
                regdst   = 0; regwrite = 0;
                jump     = 0; aluop    = 2'b01;
            end
            6'b001000: begin // addi
                memtoreg = 0; memwrite = 0;
                branch   = 0; alusrc   = 1;
                regdst   = 0; regwrite = 1;
                jump     = 0; aluop    = 2'b00;
            end
            6'b000010: begin // j
                memtoreg = 0; memwrite = 0;
                branch   = 0; alusrc   = 0;
                regdst   = 0; regwrite = 0;
                jump     = 1; aluop    = 2'b00;
            end
            default: begin
                memtoreg = 0; memwrite = 0;
                branch   = 0; alusrc   = 0;
                regdst   = 0; regwrite = 0;
                jump     = 0; aluop    = 2'b00;
            end
        endcase
    end
endmodule