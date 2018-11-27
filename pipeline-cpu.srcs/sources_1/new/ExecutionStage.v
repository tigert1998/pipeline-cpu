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
    input wire ID_EX_Regrt,
    input wire ID_EX_MemToReg,
    input wire ID_EX_WriteMem,
    input wire ID_EX_ALUImm,
    input wire [2: 0] ID_EX_ALUOperation,

    output reg [31: 0] EX_MEM_IR,
    output reg [31: 0] EX_MEM_ALUOutput,
    output reg [31: 0] EX_MEM_B,
    output reg EX_MEM_Cond,
    output reg [5: 0] EX_MEM_Opcode
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

reg [31: 0] temp_IR, temp_B, temp_ALUOutput, temp_Cond, temp_Opcode;

always @(negedge clk) begin
    temp_IR <= ID_EX_IR;
    temp_B <= ID_EX_B;
    temp_ALUOutput <= ALUOutput;
    temp_Cond <= (ID_EX_IR[31: 26] == 6'b00_0100) ? zero : !zero;
    temp_Opcode <= ID_EX_IR[31: 26];
end

always @(posedge clk) begin
    EX_MEM_IR <= temp_IR;
    EX_MEM_B <= temp_B;
    EX_MEM_ALUOutput <= temp_ALUOutput;
    EX_MEM_Cond <= temp_Cond;
    EX_MEM_Opcode <= temp_Opcode;
end

endmodule
