`timescale 1ns / 1ps

module ExecutionStage(
    input wire clk,
    
    input wire [31: 0] ID_EX_A,
    input wire [31: 0] ID_EX_B,
    input wire [31: 0] ID_EX_NPC,
    input wire [31: 0] ID_EX_IR, 
    input wire [31: 0] ID_EX_Imm,
    
    input wire ID_EX_Branch,
    input wire ID_EX_WriteReg,
    input wire ID_EX_MemToReg,
    input wire ID_EX_WriteMem,
    input wire ID_EX_ALUImm,
    input wire [2: 0] ID_EX_ALUOperation,
    input wire [4: 0] ID_EX_WriteRegAddr,

    output reg [31: 0] EX_MEM_IR,
    output reg [31: 0] EX_MEM_ALUOutput,
    output reg [31: 0] EX_MEM_B,
    output reg EX_MEM_Cond,
    output reg [5: 0] EX_MEM_Opcode,
    output reg [4: 0] EX_MEM_WriteRegAddr,
    output reg EX_MEM_WriteMem,
    output reg EX_MEM_WriteReg,
    output reg EX_MEM_MemToReg
);

wire [31: 0] ALUOutput;
wire zero;

ALU a1(
    .A(ID_EX_A),
    .B(ID_EX_ALUImm ? ID_EX_B : ID_EX_Imm),
    .ALUOperation(ID_EX_ALUOperation),
    .result(ALUOutput),
    .zero(zero)
);

always @(posedge clk) begin
    EX_MEM_IR <= ID_EX_IR;
    EX_MEM_ALUOutput <= ALUOutput;
    EX_MEM_B <= ID_EX_B;
    EX_MEM_Cond <= (ID_EX_IR[31: 26] == 6'b00_0100) ? zero : !zero;
    EX_MEM_Opcode <= ID_EX_IR[31: 26];
    EX_MEM_WriteRegAddr <= ID_EX_WriteRegAddr;
    EX_MEM_WriteMem <= ID_EX_WriteMem;
    EX_MEM_WriteReg <= ID_EX_WriteReg;
    EX_MEM_MemToReg <= ID_EX_MemToReg;
end

endmodule
