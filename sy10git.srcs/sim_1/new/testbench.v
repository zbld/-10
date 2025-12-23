`timescale 1ns / 1ps
module testbench();
    reg clk = 1'b0;
    reg rst = 1'b1;

    wire [31:0] writedata, dataadr;
    wire memwrite;

    // 端口名例化 top
    top dut (
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite),
        
        .clk(clk),
        .rst(rst)

    );

    // 时钟：20ns 周期
    always #10 clk = ~clk;

    // 复位
    initial begin
        #200;
        rst = 1'b0;
    end

    // 波形（如用 WDB，可删掉）
    initial begin
        $dumpfile("mips_tb.vcd");
        $dumpvars(0, testbench);
    end

    // 超时保护
    initial begin
        #5000;
        $display("Simulation timed out without success.");
        $stop;
    end

    // 每个周期打印 PC/Instr，便于定位
    always @(posedge clk) begin
        $display("%t PC=%h Instr=%h memwrite=%b addr=%h data=%h",
                 $time, dut.pc, dut.instr, memwrite, dataadr, writedata);
    end

    // 成功判定：地址 84，数据 7（写口在 ~clk 上升沿，相当于 clk 的下降沿）
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