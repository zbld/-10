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
    output wire[3:0] ans, //数码管位选
    output wire[6:0] seg  //数码管段选
    );

//    wire [31:0] writedata;
//    wire [31:0] dataadr;
//    wire        memwrite;

    wire [15:0] debug_reg_data;
    wire [31:0] pc, instr, readdata;
    
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

    // 指令存储器：addra 宽 8 位，取 pc[9:2]
    imem imem_inst (
//        .clka(div_clk),
        .clka(clk),
        .addra(pc[7:2]),   // 8-bit address
        .douta(instr)
    );

    // 数据存储器：addra 宽 6 位，wea 是 1-bit 向量
    data_mem dmem_inst (
//        .clka(~div_clk),               // 写时钟在 memwrite 时有效，原设计用 ~clk
        .clka(~clk),
        .wea({memwrite}),          // wea[0]=memwrite
        .addra(dataadr[9:2]),      // 6-bit address
        .dina(writedata),
        .douta(readdata)
    );

        display u_display(
        .clk(clk),
        .reset(rst),
        .s(debug_reg_data),
        .seg(seg),
        .ans(ans)
    );
    
endmodule
