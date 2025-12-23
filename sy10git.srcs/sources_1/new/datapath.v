`timescale 1ns / 1ps
module datapath(
    input  wire        clk, rst,
    input  wire        memtoreg, pcsrc,
    input  wire        alusrc, regdst,
    input  wire        regwrite, jump,
    input  wire [3:0]  alucontrol,  // Extended to 4-bit
    output wire        overflow, zero,
    output wire [31:0] pc,
    input  wire [31:0] instr,
    output wire [31:0] aluout, writedata,
    input  wire [31:0] readdata,
    
    input  wire [4:0]  debug_reg_addr,
    output wire [31:0] debug_reg_data
    );

    wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
    wire [31:0] signimm, signimmsh;
    wire [31:0] srca, srcb;
    wire [31:0] result;
    wire [4:0]  writereg;

    // PC �Ĵ���
    pc pcreg(
        .clk(clk),
        .rst(rst),
        .pcnext(pcnext),
        .pc(pc)
    );

    adder pcadd1(.a(pc), .b(32'd4), .y(pcplus4));
    adder pcadd2(.a(pcplus4), .b(signimmsh), .y(pcbranch));

    // ��תĿ�꣨�õ�ǰָ���ֶΣ�
    wire [31:0] pcjump = {pcplus4[31:28], instr[25:0], 2'b00};

    // ��֧ / ˳��
    mux2 #(32) pcmux (.d0(pcplus4), .d1(pcbranch), .s(pcsrc), .y(pcnextbr));
    // ��ת
    mux2 #(32) pcmux2(.d0(pcnextbr), .d1(pcjump),   .s(jump),  .y(pcnext));

    // �Ĵ����Ѷ���ַ����ǰָ���ֶ�
    regfile rf(
        .clk(clk),
        .we3(regwrite),
        .ra1(instr[25:21]),
        .ra2(instr[20:16]),
        .wa3(writereg),
        .wd3(result),
        .rd1(srca),
        .rd2(writedata),
        
        .ra_dbg(debug_reg_addr),
        .rd_dbg(debug_reg_data)
    );

    signext se(.a(instr[15:0]), .y(signimm));
    sl2     immsh(.a(signimm),  .y(signimmsh));

    mux2 #(5)  wrmux (.d0(instr[20:16]), .d1(instr[15:11]), .s(regdst), .y(writereg));
    mux2 #(32) srcbmux(.d0(writedata),   .d1(signimm),      .s(alusrc), .y(srcb));

    alu alu(
        .a(srca),
        .b(srcb),
        .op(alucontrol),
        .y(aluout),
        .overflow(overflow),
        .zero(zero)
    );

    mux2 #(32) resmux(.d0(aluout), .d1(readdata), .s(memtoreg), .y(result));
endmodule