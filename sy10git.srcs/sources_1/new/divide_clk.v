`timescale 1ns / 1ps


module divide_clk(
    input clk,
    inout reset,
    output purse
    );
    
    reg [31:0] count = 0;
    reg purse;
    
    // ·ÖÆµ
    always@(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0; 
            purse <= 0;
        end else begin
            if (count == 99999999) begin
                count <= 0;
                purse <= ~purse;
            end else begin
                count <= count + 32'd1; 
            end
        end
    end
    
endmodule