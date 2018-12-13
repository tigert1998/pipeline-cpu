`timescale 1ns / 1ps

module InstructionFetchStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] PC,
    input wire stall,
    
    input wire MEM_WB_GotoSeries,
    input wire [31: 0] MEM_WB_NPC,
    
    output reg [31: 0] IF_ID_IR,
    output reg [31: 0] IF_ID_NPC,
    output reg IF_ID_Bubble
);

wire [31: 0] douta;

InstructionMemory i0(
    .addra(MEM_WB_GotoSeries ? MEM_WB_NPC[10: 2] : PC[10: 2]),
    .clka(~clk),
    .dina(1'b0),
    .douta(douta),
    .ena(1'b1),
    .wea(0)
);

always @(posedge rst or posedge clk) begin
    if (rst) begin
        IF_ID_Bubble <= 1;
    end else if (stall) begin
        IF_ID_Bubble <= 0;
    end else begin
        IF_ID_IR <= douta;
        IF_ID_NPC <= PC + 4;
        IF_ID_Bubble <= 0;
    end
end
  
endmodule
