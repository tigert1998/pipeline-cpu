`timescale 1ns / 1ps

module ExecutionStage(
    input wire clk,
    input wire [31: 0] ID_EX_A, 
    input wire [31: 0] ID_EX_B, 
    input wire [31: 0] ID_EX_NPC, 
    input wire [31: 0] ID_EX_IR, 
    input wire [31: 0] ID_EX_Imm,

    output reg [31: 0] EX_MEM_IR,
    output reg [31: 0] EX_MEM_ALUOutput,
    output reg [31: 0] EX_MEM_B,
    output reg EX_MEM_Cond,
    output reg [5: 0] EX_MEM_Opcode
);

wire [1: 0] ALUOp;
wire R, Branch, BEQ, BNE;
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

wire [31: 0] ALUOutput;
wire zero;
ALU a1(
    .A((R || Branch) ?
        ID_EX_A :
        ID_EX_NPC),
    .B(R ?
        ID_EX_B :
        Branch ? (ID_EX_Imm << 2) : ID_EX_Imm),
    .ALUOperation(ALUOperation),
    .result(ALUOutput),
    .zero(zero)
);

reg [31: 0] temp_IR, temp_B, temp_ALUOutput, temp_Cond, temp_Opcode;

always @(negedge clk) begin
    temp_IR = ID_EX_IR;
    temp_B = ID_EX_B;
    temp_ALUOutput = ALUOutput;
    temp_Cond = BEQ ? zero : !zero;
    temp_Opcode = ID_EX_IR[31: 26];
end

always @(posedge clk) begin
    EX_MEM_IR <= temp_IR;
    EX_MEM_B <= temp_B;
    EX_MEM_ALUOutput <= temp_ALUOutput;
    EX_MEM_Cond <= temp_Cond;
    EX_MEM_Opcode <= temp_Opcode;
end

endmodule
