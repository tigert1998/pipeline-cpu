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
    input wire [31: 0] douta,
    
    output reg forward_rs,
    output reg [31: 0] rs_data,
    output reg forward_rt,
    output reg [31: 0] rt_data
);

wire need_check_ID_EX, need_check_EX_MEM;
assign need_check_ID_EX = 
    !ID_EX_GotoSeries && ID_EX_WriteReg && !ID_EX_MemToReg && !ID_EX_Bubble;
    
assign need_check_EX_MEM =
    !EX_MEM_GotoSeries && EX_MEM_WriteReg && EX_MEM_MemToReg && !EX_MEM_Bubble;
    
always @* begin
    if (need_check_ID_EX) begin
        forward_rs <= ReadRs && ID_EX_WriteRegAddr == rs;
        rs_data <= ALUOutput;
        forward_rt <= ReadRt && ID_EX_WriteRegAddr == rt;
        rt_data <= ALUOutput;
    end else if (need_check_EX_MEM) begin
        forward_rs <= ReadRs && EX_MEM_WriteRegAddr == rs;
        rs_data <= douta;
        forward_rt <= ReadRt && EX_MEM_WriteRegAddr == rt;
        rt_data <= douta;
    end
end

endmodule
