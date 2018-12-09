`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    
    input wire [4: 0] MEM_WB_WriteRegAddr,
    input wire MEM_WB_WriteReg,
    input wire [31: 0] MEM_WB_WriteData,

    output reg [31: 0] ID_EX_A,
    output reg [31: 0] ID_EX_B,
    output wire [31: 0] ID_EX_NPC,
    output reg [31: 0] ID_EX_IR,
    output reg [31: 0] ID_EX_Imm,
    output reg [4: 0] ID_EX_ShiftAmount,
    
    output reg ID_EX_Branch,
    output reg ID_EX_WriteReg,
    output reg ID_EX_MemToReg,
    output reg ID_EX_WriteMem,
    output reg ID_EX_ALUSA,
    output reg ID_EX_ALUImm,
    output reg [3: 0] ID_EX_ALUOperation,
    output reg [4: 0] ID_EX_WriteRegAddr
);

wire Branch, WriteReg, Regrt, MemToReg, WriteMem, ALUSA, ALUImm, SignExtendImm;
wire [3: 0] ALUOperation;
wire [4: 0] ShiftAmount;
ControlUnit c0(
    .Instruction(IF_ID_IR),
    .Branch(Branch),
    .WriteReg(WriteReg),
    .Regrt(Regrt),
    .MemToReg(MemToReg),
    .WriteMem(WriteMem),
    .ALUSA(ALUSA),
    .ALUImm(ALUImm),
    .SignExtendImm(SignExtendImm),
    .ALUOperation(ALUOperation),
    .ShiftAmount(ShiftAmount)
);

wire [31: 0] ReadData1, ReadData2;
Registers r0(
    .clk(~clk),
    .rst(rst),
    .WriteReg(MEM_WB_WriteReg),
    .ReadRegAddr1(IF_ID_IR[25: 21]),
    .ReadRegAddr2(IF_ID_IR[20: 16]),
    .ReadRegAddr3(),
    .WriteRegAddr(MEM_WB_WriteRegAddr),
    .WriteData(MEM_WB_WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .ReadData3()
);

wire [31: 0] SignExtendedImm, ZeroExtendedImm;
SignExtend s0(
    .I(IF_ID_IR[15: 0]),
    .O(SignExtendedImm)
);
ZeroExtend z0(
    .I(IF_ID_IR[15: 0]),
    .O(ZeroExtendedImm)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ID_EX_WriteReg <= 0;
        ID_EX_WriteMem <= 0;
    end else begin
        ID_EX_A <= ReadData1;
        ID_EX_B <= ReadData2;
        // ID_EX_NPC
        ID_EX_IR <= IF_ID_IR;
        ID_EX_Imm <= SignExtendImm ? SignExtendedImm : ZeroExtendedImm;
        ID_EX_ShiftAmount <= ShiftAmount;
   
        ID_EX_Branch <= Branch;
        ID_EX_WriteReg <= WriteReg;
        ID_EX_MemToReg <= MemToReg;
        ID_EX_WriteMem <= WriteMem;
        ID_EX_ALUSA <= ALUSA;
        ID_EX_ALUImm <= ALUImm;
        ID_EX_ALUOperation <= ALUOperation;
        ID_EX_WriteRegAddr <= Regrt ? IF_ID_IR[20: 16] : IF_ID_IR[15: 11];
    end
end

endmodule
