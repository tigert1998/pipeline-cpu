`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    
//    input wire [31: 0] MEM_WB_,
//    input wire MEM_WB_RegWrite,
//    input wire [31: 0] MEM_WB_ALUOutput,
    
    output reg [31: 0] ID_EX_A,
    output reg [31: 0] ID_EX_B,
    output wire [31: 0] ID_EX_NPC,
    output reg [31: 0] ID_EX_IR,
    output reg [31: 0] ID_EX_Imm,
    
    output reg ID_EX_Branch,
    output reg ID_EX_WriteReg,
    output reg ID_EX_Regrt,
    output reg ID_EX_MemToReg,
    output reg ID_EX_WriteMem,
    output reg ID_EX_ALUImm,
    output reg [2: 0] ID_EX_ALUOperation
);

wire Branch, WriteReg, Regrt, MemToReg, WriteMem, ALUImm;
wire [2: 0] ALUOperation;
ControlUnit c0(
    .instruction(IF_ID_IR),
    .Branch(Branch),
    .WriteReg(WriteReg),
    .Regrt(Regrt),
    .MemToReg(MemToReg),
    .WriteMem(WriteMem),
    .ALUImm(ALUImm),
    .ALUOperation(ALUOperation)
);

wire [31: 0] ReadData1, ReadData2;
Registers r0(
    .clk(),
    .rst(rst),
    .RegWrite(),
    .ReadRegAddr1(IF_ID_IR[25: 21]),
    .ReadRegAddr2(IF_ID_IR[20: 16]),
    .ReadRegAddr3(),
    .WriteRegAddr(),
    .WriteData(),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .ReadData3()
);

wire [31: 0] o;
SignExtend s0(
    .i(IF_ID_IR[15: 0]),
    .o(o)
);

reg [31: 0] temp_Imm, temp_A, temp_B, temp_IR;
reg temp_Branch, temp_WriteReg, temp_Regrt, temp_MemToReg, temp_WriteMem, temp_ALUImm;
reg [2: 0] temp_ALUOperation;
always @(negedge clk) begin
    temp_Imm <= o;
    temp_A <= ReadData1;
    temp_B <= ReadData2;
    temp_IR <= IF_ID_IR;
    temp_Branch <= Branch;
    temp_WriteReg <= WriteReg;
    temp_Regrt <= Regrt;
    temp_MemToReg <= MemToReg;
    temp_WriteMem <= WriteMem;
    temp_ALUImm <= ALUImm;
    temp_ALUOperation <= ALUOperation;
end

always @(posedge clk) begin
    ID_EX_Imm <= temp_Imm;
    ID_EX_A <= temp_A;
    ID_EX_B <= temp_B;
    ID_EX_IR <= temp_IR;
    ID_EX_Branch <= temp_Branch;
    ID_EX_WriteReg <= temp_WriteReg;
    ID_EX_Regrt <= temp_Regrt;
    ID_EX_MemToReg <= temp_MemToReg;
    ID_EX_WriteMem <= temp_WriteMem;
    ID_EX_ALUImm <= temp_ALUImm;
    ID_EX_ALUOperation <= temp_ALUOperation;
end

endmodule
