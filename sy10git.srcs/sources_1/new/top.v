`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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



`timescale 1ns / 1ps
module top(
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] writedata,
    output wire [31:0] dataadr,
    output wire        memwrite,
    
    input  wire [4:0]  sw_dbg,
    input  wire [15:0] switch_value,  // 16-bit switch input for peripheral I/O
    output wire[3:0] ans, //�����λѡ
    output wire[6:0] seg  //����ܶ�ѡ
    );

//    wire [31:0] writedata;
//    wire [31:0] dataadr;
//    wire        memwrite;

    wire [15:0] debug_reg_data;
    wire [31:0] pc, instr, readdata;
    wire [31:0] readdata_mem;  // Data from memory
    
//    wire div_clk;
    
//    divide_clk div(
//    .clk(clk),
//    .reset(rst),
//    .purse(div_clk)
//    );

    mips mips(
//        .clk(div_clk),
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instr(instr),
        .memwrite(memwrite),
        .aluout(dataadr),
        .writedata(writedata),
        .readdata(readdata),
        
        .debug_reg_addr(sw_dbg),
        .debug_reg_data(debug_reg_data)
    );
    
    // Peripheral I/O multiplexer: 0x0-0x3FFF is memory, 0x4000+ is peripheral
    // Address 0x4000 maps to switch input
    assign readdata = (dataadr[14] == 1'b0) ? readdata_mem : {16'b0, switch_value};

    // ָ��洢����addra �� 8 λ��ȡ pc[9:2]
    imem imem_inst (
//        .clka(div_clk),
        .clka(clk),
        .addra(pc[7:2]),   // 8-bit address
        .douta(instr)
    );

    // ���ݴ洢����addra �� 6 λ��wea �� 1-bit ����
    data_mem dmem_inst (
//        .clka(~div_clk),               // дʱ���� memwrite ʱ��Ч��ԭ����� ~clk
        .clka(~clk),
        .wea({memwrite}),          // wea[0]=memwrite
        .addra(dataadr[9:2]),      // 6-bit address
        .dina(writedata),
        .douta(readdata_mem)       // Connect to readdata_mem instead of readdata
    );

        display u_display(
        .clk(clk),
        .reset(rst),
        .s(debug_reg_data),
        .seg(seg),
        .ans(ans)
    );
    
endmodule
