`timescale 1ns / 1ps

module MemoryStage(
    input wire clk,
    input wire rst,
    
    // input pipeline registers
    input wire [31: 0] EX_MEM_IR,
    input wire [31: 0] EX_MEM_ALUOutput,
    input wire [31: 0] EX_MEM_B,
    input wire EX_MEM_Cond,
    input wire [5: 0] EX_MEM_Opcode,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_WriteMem,
    input wire EX_MEM_WriteReg,
    input wire EX_MEM_MemToReg,
    input wire EX_MEM_Bubble,

    // output pipeline registers
    output reg [31: 0] MEM_WB_IR,
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

always @(posedge clk or posedge rst) begin
    if (rst || EX_MEM_Bubble) begin
        MEM_WB_WriteReg <= 0;
    end else begin
        MEM_WB_IR <= EX_MEM_IR;
        MEM_WB_WriteRegAddr <= EX_MEM_WriteRegAddr;
        MEM_WB_WriteReg <= EX_MEM_WriteReg;
        MEM_WB_WriteData <= EX_MEM_MemToReg ? douta : EX_MEM_ALUOutput;
    end
end

endmodule
