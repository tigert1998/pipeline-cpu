`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    output wire [31: 0] ID_EX_A, 
    output wire [31: 0] ID_EX_B, 
    output wire [31: 0] ID_EX_NPC, 
    output wire [31: 0] ID_EX_IR, 
    output wire [31: 0] ID_EX_Imm
);
    
Registers r0(
    .clk(),
    .rst(rst),
    .RegWrite(),
    .ReadRegAddr1(IF_ID_IR[25: 21]),
    .ReadRegAddr2(IF_ID_IR[20: 16]),
    .ReadRegAddr3(),
    .WriteRegAddr(),
    .WriteData(),
    .ReadData1(ID_EX_A),
    .ReadData2(ID_EX_B),
    .ReadData3()
);

SignExtend s0(
    .i(IF_ID_IR[15: 0]),
    .o(ID_EX_Imm)
);

endmodule
