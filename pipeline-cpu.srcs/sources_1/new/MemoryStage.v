`timescale 1ns / 1ps

module MemoryStage(
    input wire clk,
    
    input wire [31: 0] EX_MEM_IR,
    input wire [31: 0] EX_MEM_ALUOutput,
    input wire [31: 0] EX_MEM_B,
    input wire EX_MEM_Cond,
    input wire [5: 0] EX_MEM_Opcode,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_WriteMem,
    input wire EX_MEM_WriteReg,
    input wire EX_MEM_MemToReg,

    output reg [31: 0] MEM_WB_IR,
    output reg [31: 0] MEM_WB_ALUOutput,
    output reg [31: 0] MEM_WB_LMD,
    output reg [4: 0] MEM_WB_WriteRegAddr,
    output reg MEM_WB_WriteReg,
    output reg [31: 0] MEM_WB_WriteData
);

wire [31: 0] douta;

DataMemory d0(
    .addra(EX_MEM_ALUOutput),
    .clka(~clk),
    .dina(EX_MEM_B),
    .douta(douta),
    .ena(1),
    .wea(EX_MEM_WriteMem)
);

always @(posedge clk) begin
    MEM_WB_IR <= EX_MEM_IR;
    MEM_WB_ALUOutput <= EX_MEM_ALUOutput;
    MEM_WB_LMD <= douta;
    MEM_WB_WriteRegAddr <= EX_MEM_WriteRegAddr;
end

endmodule