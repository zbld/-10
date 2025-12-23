`timescale 1ns / 1ps
module testbench();
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [4:0] sw_dbg = 5'b00000;
    reg [15:0] switch_value = 16'h0000;

    wire [31:0] writedata, dataadr;
    wire memwrite;
    wire [3:0] ans;
    wire [6:0] seg;

    // �˿������� top
    top dut (
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite),
        
        .clk(clk),
        .rst(rst),
        .sw_dbg(sw_dbg),
        .switch_value(switch_value),
        .ans(ans),
        .seg(seg)
    );

    // ʱ�ӣ�20ns ����
    always #10 clk = ~clk;

    // ��λ
    initial begin
        #200;
        rst = 1'b0;
    end

    // ���Σ����� WDB����ɾ����
    initial begin
        $dumpfile("mips_tb.vcd");
        $dumpvars(0, testbench);
    end

    // ��ʱ����
    initial begin
        #5000;
        $display("Simulation timed out without success.");
        $stop;
    end

    // ÿ�����ڴ�ӡ PC/Instr�����ڶ�λ
    always @(posedge clk) begin
        $display("%t PC=%h Instr=%h memwrite=%b addr=%h data=%h",
                 $time, dut.pc, dut.instr, memwrite, dataadr, writedata);
    end

    // �ɹ��ж�����ַ 84������ 7��д���� ~clk �����أ��൱�� clk ���½��أ�
    always @(negedge clk) begin
        if (memwrite) begin
            $display("%t MEMWRITE addr=%0d (0x%h) data=%0d (0x%h)",
                     $time, dataadr, dataadr, writedata, writedata);
            if (dataadr === 32'd84 && writedata === 32'd7) begin
                $display("Simulation succeeded");
                $stop;
            end
        end
    end
endmodule