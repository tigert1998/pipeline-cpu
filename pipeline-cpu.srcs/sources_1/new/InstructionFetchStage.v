`timescale 1ns / 1ps

module InstructionFetchStage(
    input wire rst,
    input wire clk,
    input wire [31: 0] PC,
    input wire stall,
    
    output reg [31: 0] IF_ID_IR,
    output wire [31: 0] IF_ID_NPC,
    output reg IF_ID_Bubble
);

wire [31: 0] douta;

InstructionMemory i0(
    .addra(PC),
    .clka(~clk),
    .dina(0),
    .douta(douta),
    .ena(1),
    .wea(0)
);

always @(posedge rst or posedge clk) begin
    if (rst) begin
        IF_ID_Bubble <= 1;
    end else if (stall) begin
        IF_ID_Bubble <= 0;
    end else begin
        IF_ID_IR <= douta;
        // IF_ID_NPC
        IF_ID_Bubble <= 0;
    end
end
  
endmodule
