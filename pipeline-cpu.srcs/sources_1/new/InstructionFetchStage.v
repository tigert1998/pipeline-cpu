`timescale 1ns / 1ps

module InstructionFetchStage(
    input wire [31: 0] clk,
    input wire [31: 0] PC,
    output wire [31: 0] IF_ID_IR,
    output wire [31: 0] IF_ID_NPC
);

InstructionMemory i0(
    .addra(PC),
    .clka(clk),
    .dina(0),
    .douta(IF_ID_IR),
    .ena(1),
    .wea(0)
);
  
endmodule
