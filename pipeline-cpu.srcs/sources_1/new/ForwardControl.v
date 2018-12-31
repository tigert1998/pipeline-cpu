`timescale 1ns / 1ps

module ForwardControl(
    input wire ReadRs,
    input wire [4: 0] rs,
    input wire ReadRt,
    input wire [4: 0] rt,
    
    input wire ID_EX_GotoSeries,
    input wire ID_EX_WriteReg,
    input wire ID_EX_MemToReg,
    input wire [4: 0] ID_EX_WriteRegAddr,
    input wire ID_EX_Bubble,
    input wire [31: 0] ALUOutput,
    
    input wire EX_MEM_GotoSeries,
    input wire EX_MEM_WriteReg,
    input wire EX_MEM_MemToReg,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_Bubble,
    input wire [31: 0] WriteData,
    
    output reg ForwardRs,
    output reg [31: 0] rs_data,
    output reg ForwardRt,
    output reg [31: 0] rt_data
);

wire need_check_ID_EX, need_check_EX_MEM;
assign need_check_ID_EX = 
    !ID_EX_GotoSeries && ID_EX_WriteReg && !ID_EX_MemToReg && !ID_EX_Bubble;
    
assign need_check_EX_MEM =
    !EX_MEM_GotoSeries && EX_MEM_WriteReg && !EX_MEM_Bubble;

wire [1: 0] rs_match_p, rt_match_p;
assign rs_match_p =
    (need_check_ID_EX && ID_EX_WriteRegAddr == rs) ? 2'd1 : 
    (need_check_EX_MEM && EX_MEM_WriteRegAddr == rs) ? 2'd2 :
    2'd0;
assign rt_match_p =
    (need_check_ID_EX && ID_EX_WriteRegAddr == rt) ? 2'd1 : 
    (need_check_EX_MEM && EX_MEM_WriteRegAddr == rt) ? 2'd2 :
    2'd0;

always @* begin
    if (!ReadRs) begin
        ForwardRs <= 1'd0;
        rs_data <= 32'dx;
    end else begin
        ForwardRs <= (rs_match_p != 2'd0);
        rs_data <= 
            (rs_match_p == 2'd0) ? 32'dx :
            (rs_match_p == 2'd1) ? ALUOutput :
            WriteData;
    end
    
    if (!ReadRt) begin
        ForwardRt <= 1'd0;
        rt_data <= 32'dx;
    end else begin
        ForwardRt <= (rt_match_p != 2'd0);
        rt_data <= 
            (rt_match_p == 2'd0) ? 32'dx :
            (rt_match_p == 2'd1) ? ALUOutput :
            WriteData;
    end
end

endmodule
