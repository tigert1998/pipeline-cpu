`timescale 1ns / 1ps

module MemoryStage(
    input wire clk,
    input wire rst,
    
    // input pipeline registers
    input wire [31: 0] EX_MEM_NPC,
    input wire [31: 0] EX_MEM_IR,
    input wire [31: 0] EX_MEM_ALUOutput,
    input wire [31: 0] EX_MEM_B,
    input wire [5: 0] EX_MEM_Opcode,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_WriteMem,
    input wire EX_MEM_WriteReg,
    input wire EX_MEM_MemToReg,
    input wire EX_MEM_GotoSeries,
    input wire EX_MEM_BranchTaken,
    input wire EX_MEM_Bubble,

    // output pipeline registers
    output reg [31: 0] MEM_WB_NPC,
    output reg [31: 0] MEM_WB_IR,
    output reg [4: 0] MEM_WB_WriteRegAddr,
    output reg MEM_WB_WriteReg,
    output reg [31: 0] MEM_WB_WriteData,
    output reg MEM_WB_GotoSeries,
    output reg MEM_WB_BranchTaken,
    
    // special output
    output wire [31: 0] WriteData
);

wire [31: 0] douta;

DataMemory d0(
    .addra(EX_MEM_ALUOutput[12: 2]),
    .clka(~clk),
    .dina(EX_MEM_B),
    .douta(douta),
    .ena(1),
    .wea(EX_MEM_WriteMem)
);

assign WriteData = EX_MEM_MemToReg ? douta : EX_MEM_ALUOutput;

always @(posedge clk or posedge rst) begin
    if (rst || EX_MEM_Bubble) begin
        MEM_WB_WriteReg <= 0;
        MEM_WB_GotoSeries <= 0;
        MEM_WB_BranchTaken <= 0;
        
    end else begin
        MEM_WB_NPC <= EX_MEM_NPC;
        MEM_WB_IR <= EX_MEM_IR;
        MEM_WB_WriteRegAddr <= EX_MEM_WriteRegAddr;
        MEM_WB_WriteReg <= EX_MEM_WriteReg;
        MEM_WB_WriteData <= WriteData;
        MEM_WB_GotoSeries <= EX_MEM_GotoSeries;
        MEM_WB_BranchTaken <= EX_MEM_BranchTaken;
    end
end

endmodule
