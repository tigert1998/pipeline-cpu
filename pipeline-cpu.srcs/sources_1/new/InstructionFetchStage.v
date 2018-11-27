`timescale 1ns / 1ps

module InstructionFetchStage(
    input wire [31: 0] clk,
    input wire [31: 0] PC,
    output reg [31: 0] IF_ID_IR,
    output wire [31: 0] IF_ID_NPC
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

always @(posedge clk) begin
    IF_ID_IR = douta;
end
  
endmodule
