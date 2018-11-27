`timescale 1ns / 1ps

module MemoryStage(
    input wire clk,
    input wire [31: 0] EX_MEM_IR,
    input wire [31: 0] EX_MEM_ALUOutput,
    input wire [31: 0] EX_MEM_B,

    output reg [31: 0] MEM_WB_IR,
    output reg [31: 0] MEM_WB_ALUOutput,
    output reg [31: 0] MEM_WB_LMD
);

reg [31: 0] temp_IR, temp_ALUOutput;

wire [31: 0] douta;

DataMemory d0(
    .addra(EX_MEM_ALUOutput),
    .clka(~clk),
    .dina(EX_MEM_B),
    .douta(douta),
    .ena(1),
    .wea(0)
);

always @(negedge clk) begin
    temp_IR = EX_MEM_IR;
    temp_ALUOutput = EX_MEM_ALUOutput;
end

always @(posedge clk) begin
    MEM_WB_IR = temp_IR;
    MEM_WB_ALUOutput = temp_ALUOutput;
    MEM_WB_LMD = douta;
end

endmodule
