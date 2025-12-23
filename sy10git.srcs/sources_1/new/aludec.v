`timescale 1ns / 1ps
module aludec(
    input  wire [5:0] funct,
    input  wire [1:0] aluop,
    output reg  [3:0] alucontrol  // Extended to 4-bit
);
    always @(*) begin
        case (aluop)
            2'b00: alucontrol = 4'b0010; // add
            2'b01: alucontrol = 4'b0110; // sub
            default: begin
                case (funct)
                    6'b100000: alucontrol = 4'b0010; // add
                    6'b100010: alucontrol = 4'b0110; // sub
                    6'b100100: alucontrol = 4'b0000; // and
                    6'b100101: alucontrol = 4'b0001; // or
                    6'b101010: alucontrol = 4'b0111; // slt
                    6'b000100: alucontrol = 4'b1000; // sllv - shift left logical variable
                    6'b000110: alucontrol = 4'b1001; // srlv - shift right logical variable
                    default:   alucontrol = 4'b0010;
                endcase
            end
        endcase
    end
endmodule