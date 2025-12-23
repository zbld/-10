`timescale 1ns / 1ps
module controller(
    input  wire [5:0] op,
    input  wire [5:0] funct,
    input  wire       zero,
    output wire       memtoreg,
    output wire       memwrite,
    output wire       pcsrc,
    output wire       alusrc,
    output wire       regdst,
    output wire       regwrite,
    output wire       jump,
    output wire [3:0] alucontrol  // Extended to 4-bit
);
    wire [1:0] aluop;
    wire branch;

    maindec md(
        .op(op),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .branch(branch),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .aluop(aluop)
    );

    aludec ad(
        .funct(funct),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );

    assign pcsrc = branch & zero;
endmodule