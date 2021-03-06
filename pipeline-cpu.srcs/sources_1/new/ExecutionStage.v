`timescale 1ns / 1ps

module ExecutionStage(
    input wire clk,
    input wire rst,
    
    // input pipeline registers
    input wire [31: 0] ID_EX_A,
    input wire [31: 0] ID_EX_B,
    input wire [31: 0] ID_EX_NPC,
    input wire [31: 0] ID_EX_IR, 
    input wire [31: 0] ID_EX_Imm,
    input wire [4: 0] ID_EX_ShiftAmount,
    
    input wire ID_EX_JAL,
    input wire [31: 0] ID_EX_JAL_WriteData,
    input wire ID_EX_WriteReg,
    input wire ID_EX_MemToReg,
    input wire ID_EX_WriteMem,
    input wire ID_EX_ALUSA,
    input wire ID_EX_ALUImm,
    input wire ID_EX_GotoSeries,
    input wire [3: 0] ID_EX_ALUOperation,
    input wire [4: 0] ID_EX_WriteRegAddr,
    input wire ID_EX_BranchTaken,
    
    input wire ID_EX_Bubble,

    // output pipeline registers
    output reg [31: 0] EX_MEM_NPC,
    output reg [31: 0] EX_MEM_IR,
    output reg [31: 0] EX_MEM_ALUOutput,
    output reg [31: 0] EX_MEM_B,
    output reg [5: 0] EX_MEM_Opcode,
    output reg [4: 0] EX_MEM_WriteRegAddr,
    output reg EX_MEM_WriteMem,
    output reg EX_MEM_WriteReg,
    output reg EX_MEM_MemToReg,
    output reg EX_MEM_GotoSeries,
    output reg EX_MEM_BranchTaken,
    
    output reg EX_MEM_Bubble,
    
    // special output
    output wire [31: 0] ALUOutput
);

wire zero;

ALU a1(
    .A(ID_EX_ALUSA ? ID_EX_ShiftAmount : ID_EX_A),
    .B(ID_EX_ALUImm ? ID_EX_Imm : ID_EX_B),
    .ALUOperation(ID_EX_ALUOperation),
    .result(ALUOutput),
    .zero(zero)
);

always @(posedge clk or posedge rst) begin
    if (rst || ID_EX_Bubble) begin
        EX_MEM_WriteMem <= 0;
        EX_MEM_WriteReg <= 0;
        EX_MEM_GotoSeries <= 0;
        EX_MEM_BranchTaken <= 0;
        
        EX_MEM_Bubble <= 1;
        
    end else begin
        EX_MEM_NPC <= ID_EX_NPC;
        EX_MEM_IR <= ID_EX_IR;
        EX_MEM_ALUOutput <= ID_EX_JAL ? ID_EX_JAL_WriteData : ALUOutput;
        EX_MEM_B <= ID_EX_B;
        EX_MEM_Opcode <= ID_EX_IR[31: 26];
        EX_MEM_WriteRegAddr <= ID_EX_WriteRegAddr;
        EX_MEM_WriteMem <= ID_EX_WriteMem;
        EX_MEM_WriteReg <= ID_EX_WriteReg;
        EX_MEM_MemToReg <= ID_EX_MemToReg;
        EX_MEM_GotoSeries <= ID_EX_GotoSeries;
        EX_MEM_BranchTaken <= ID_EX_BranchTaken;
        
        EX_MEM_Bubble <= 0;
    end
end

endmodule
