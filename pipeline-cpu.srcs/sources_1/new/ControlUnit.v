`timescale 1ns / 1ps

module ControlUnit(
    input wire [31: 0] instruction,
    
    output wire Branch,
    output wire RegWrite,
    output wire Regrt,
    output wire MemToReg,
    output wire WriteMem,
    output wire ALUImm,
    output wire [2: 0] ALUOperation
);

wire [5: 0] Opcode;
wire [1: 0] ALUOp;
wire BEQ, BNE, R, LW, SW;
assign Opcode = instruction[31: 26];
assign R = Opcode == 6'b00_0000;
assign BEQ = Opcode == 6'b00_0100;
assign BNE = Opcode == 6'b00_0101;
assign LW = Opcode == 6'b10_0011;
assign SW = Opcode == 6'b10_1011;
assign ALUOp = {R, Branch};

assign Branch = BEQ || BNE;
assign RegWrite = R || LW;
assign Regrt = LW || SW;
assign MemToReg = LW;
assign WriteMem = SW;
assign ALUImm = LW || SW;

ALUControl a0(
    .Func(Opcode),
    .ALUOp(ALUOp),
    .ALUOperation(ALUOperation)
);

endmodule
