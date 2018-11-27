`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    output reg [31: 0] ID_EX_A,
    output reg [31: 0] ID_EX_B,
    output wire [31: 0] ID_EX_NPC, 
    output reg [31: 0] ID_EX_IR, 
    output reg [31: 0] ID_EX_Imm
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
always @(negedge clk) begin
    temp_Imm <= o;
    temp_A <= ReadData1;
    temp_B <= ReadData2;
    temp_IR <= IF_ID_IR;
end

always @(posedge clk) begin
    ID_EX_Imm <= temp_Imm;
    ID_EX_A <= temp_A;
    ID_EX_B <= temp_B;
    ID_EX_IR <= temp_IR;
end

endmodule
