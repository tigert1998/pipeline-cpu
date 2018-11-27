`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    
    input wire [4: 0] MEM_WB_RegWriteAddr,
    input wire MEM_WB_RegWrite,
    input wire [31: 0] MEM_WB_WriteData,

    output reg [31: 0] ID_EX_A,
    output reg [31: 0] ID_EX_B,
    output wire [31: 0] ID_EX_NPC,
    output reg [31: 0] ID_EX_IR,
    output reg [31: 0] ID_EX_Imm,
    
    output reg ID_EX_Branch,
    output reg ID_EX_RegWrite,
    output reg ID_EX_MemToReg,
    output reg ID_EX_WriteMem,
    output reg ID_EX_ALUImm,
    output reg [2: 0] ID_EX_ALUOperation,
    output reg [4: 0] ID_EX_RegWriteAddr
);

wire Branch, RegWrite, Regrt, MemToReg, WriteMem, ALUImm;
wire [2: 0] ALUOperation;
ControlUnit c0(
    .instruction(IF_ID_IR),
    .Branch(Branch),
    .RegWrite(RegWrite),
    .Regrt(Regrt),
    .MemToReg(MemToReg),
    .WriteMem(WriteMem),
    .ALUImm(ALUImm),
    .ALUOperation(ALUOperation)
);

wire [31: 0] ReadData1, ReadData2;
Registers r0(
    .clk(~clk),
    .rst(rst),
    .RegWrite(MEM_WB_RegWrite),
    .ReadRegAddr1(IF_ID_IR[25: 21]),
    .ReadRegAddr2(IF_ID_IR[20: 16]),
    .ReadRegAddr3(),
    .RegWriteAddr(MEM_WB_RegWriteAddr),
    .WriteData(MEM_WB_WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .ReadData3()
);

wire [31: 0] o;
SignExtend s0(
    .i(IF_ID_IR[15: 0]),
    .o(o)
);

always @(posedge clk) begin
    ID_EX_Imm <= o;
    ID_EX_A <= ReadData1;
    ID_EX_B <= ReadData2;
    ID_EX_IR <= IF_ID_IR;
    ID_EX_Branch <= Branch;
    ID_EX_RegWrite <= RegWrite;
    ID_EX_MemToReg <= MemToReg;
    ID_EX_WriteMem <= WriteMem;
    ID_EX_ALUImm <= ALUImm;
    ID_EX_ALUOperation <= ALUOperation;
    ID_EX_RegWriteAddr <= Regrt ? IF_ID_IR[20: 16] : IF_ID_IR[15: 11];
end

endmodule
