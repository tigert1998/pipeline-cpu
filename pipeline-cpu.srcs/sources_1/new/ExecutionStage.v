`timescale 1ns / 1ps

module ExecutionStage(
    input wire [31: 0] ID_EX_A, 
    input wire [31: 0] ID_EX_B, 
    input wire [31: 0] ID_EX_NPC, 
    input wire [31: 0] ID_EX_IR, 
    input wire [31: 0] ID_EX_Imm,

    output wire [31: 0] EX_MEM_IR,
    output wire [31: 0] EX_MEM_ALUOutput,
    output wire [31: 0] EX_MEM_B,
    output wire EX_MEM_Cond,
    output wire [5: 0] EX_MEM_Opcode
);

wire [1: 0] ALUOp;
wire R, Branch, BEQ, BNE;
assign EX_MEM_Opcode = ID_EX_IR[31: 26];
assign R = EX_MEM_Opcode == 6'b00_0000;
assign BEQ = EX_MEM_Opcode == 6'b00_0100;
assign BNE = EX_MEM_Opcode == 6'b00_0101;
assign Branch = BEQ || BNE;
assign ALUOp = {R, Branch};

wire [2: 0] ALUOperation;
ALUControl a0(
    .Func(ID_EX_IR[5: 0]),
    .ALUOp(ALUOp),
    .ALUOperation(ALUOperation)
);

ALU a1(
    .A((R || Branch) ?
        ID_EX_A :
        ID_EX_NPC),
    .B(R ?
        ID_EX_B :
        Branch ? (ID_EX_Imm << 2) : ID_EX_Imm),
    .ALUOperation(ALUOperation),
    .result(EX_MEM_ALUOutput),
    .zero(EX_MEM_Cond)
);

assign EX_MEM_IR = ID_EX_IR;
assign EX_MEM_B = ID_EX_B;

endmodule
