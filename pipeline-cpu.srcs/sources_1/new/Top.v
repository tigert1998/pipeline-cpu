`timescale 1ns / 1ps

module Top(
    input wire clk,
    input wire rst
);

// pipeline registers
reg [31: 0] PC;

reg [31: 0] IF_ID_IR, IF_ID_NPC;

reg [31: 0] ID_EX_A, ID_EX_B, ID_EX_NPC, ID_EX_IR, ID_EX_Imm;

reg [31: 0] EX_MEM_IR, EX_MEM_ALUOutput, EX_MEM_B, EX_MEM_Cond, EX_MEM_Opcode;

reg [31: 0] MEM_WB_IR, MEM_WB_ALUOutput, MEM_WB_LMD;

// IF
InstructionFetchStage s0(
    .clk(clk),
    .PC(PC),
    .IF_ID_IR(),
    .IF_ID_NPC()
);

// ID
InstructionDecodeStage s1(
    .rst(rst),
    .clk(),
    .IF_ID_IR(),
    .IF_ID_NPC(),
    .ID_EX_A(), 
    .ID_EX_B(), 
    .ID_EX_NPC(), 
    .ID_EX_IR(), 
    .ID_EX_Imm()
);

// EX
ExecutionStage s2(
    .ID_EX_A(),
    .ID_EX_B(),
    .ID_EX_NPC(), 
    .ID_EX_IR(), 
    .ID_EX_Imm(),
    
    .EX_MEM_IR(),
    .EX_MEM_ALUOutput(),
    .EX_MEM_B(),
    .EX_MEM_Cond(), 
    .EX_MEM_Opcode()
);

// MEM
MemoryStage s3(
);

always @(posedge clk) begin
    // IF
    
    // ID
    
    // EX
    
    // MEM
    
    // WB
end

endmodule
