`timescale 1ns / 1ps

module Top(
    input wire clk,
    input wire rst
);

reg [31: 0] PC;
wire stall;

// pipeline registers
// IF/ID
wire [31: 0] IF_ID_IR, IF_ID_NPC;
wire IF_ID_Bubble;

// ID/EX
wire [31: 0] ID_EX_A, ID_EX_B, ID_EX_NPC, ID_EX_IR, ID_EX_Imm;
wire [4: 0] ID_EX_ShiftAmount;
wire ID_EX_Branch, ID_EX_WriteReg, ID_EX_MemToReg, ID_EX_WriteMem, ID_EX_ALUSA, ID_EX_ALUImm;
wire [3: 0] ID_EX_ALUOperation;
wire [4: 0] ID_EX_WriteRegAddr;
wire ID_EX_Bubble;

// EX/MEM
wire [31: 0] EX_MEM_IR, EX_MEM_ALUOutput, EX_MEM_B;
wire EX_MEM_Cond;
wire [5: 0] EX_MEM_Opcode;
wire [4: 0] EX_MEM_WriteRegAddr;
wire EX_MEM_WriteMem, EX_MEM_WriteReg, EX_MEM_MemToReg, EX_MEM_Bubble;

// MEM/WB
wire [31: 0] MEM_WB_IR;
wire [4: 0] MEM_WB_WriteRegAddr;
wire MEM_WB_WriteReg;
wire [31: 0] MEM_WB_WriteData;

// IF
InstructionFetchStage s0(
    .rst(rst),
    .clk(clk),
    .PC(PC),
    .stall(stall),
    
    .IF_ID_IR(IF_ID_IR),
    .IF_ID_NPC(IF_ID_NPC),
    .IF_ID_Bubble(IF_ID_Bubble)
);

// ID
InstructionDecodeStage s1(
    .rst(rst),
    .clk(clk),
    .IF_ID_IR(IF_ID_IR),
    .IF_ID_NPC(IF_ID_NPC),
    .IF_ID_Bubble(IF_ID_Bubble),
    
    .EX_MEM_WriteRegAddr(EX_MEM_WriteRegAddr),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_Bubble(EX_MEM_Bubble),
    
    .MEM_WB_WriteRegAddr(MEM_WB_WriteRegAddr),
    .MEM_WB_WriteReg(MEM_WB_WriteReg),
    .MEM_WB_WriteData(MEM_WB_WriteData),

    .ID_EX_A(ID_EX_A),
    .ID_EX_B(ID_EX_B),
    .ID_EX_NPC(ID_EX_NPC),
    .ID_EX_IR(ID_EX_IR),
    .ID_EX_Imm(ID_EX_Imm),
    .ID_EX_ShiftAmount(ID_EX_ShiftAmount),
    
    .ID_EX_Branch(ID_EX_Branch),
    .ID_EX_WriteReg(ID_EX_WriteReg),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_WriteMem(ID_EX_WriteMem),
    .ID_EX_ALUSA(ID_EX_ALUSA),
    .ID_EX_ALUImm(ID_EX_ALUImm),
    .ID_EX_ALUOperation(ID_EX_ALUOperation),
    .ID_EX_WriteRegAddr(ID_EX_WriteRegAddr),
    
    .ID_EX_Bubble(ID_EX_Bubble),
    
    .stall(stall)
);

// EX
ExecutionStage s2(
    .clk(clk),
    .rst(rst),
    
    .ID_EX_A(ID_EX_A),
    .ID_EX_B(ID_EX_B),
    .ID_EX_NPC(ID_EX_NPC),
    .ID_EX_IR(ID_EX_IR), 
    .ID_EX_Imm(ID_EX_Imm),
    .ID_EX_ShiftAmount(ID_EX_ShiftAmount),
    
    .ID_EX_Branch(ID_EX_Branch),
    .ID_EX_WriteReg(ID_EX_WriteReg),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_WriteMem(ID_EX_WriteMem),
    .ID_EX_ALUSA(ID_EX_ALUSA),
    .ID_EX_ALUImm(ID_EX_ALUImm),
    .ID_EX_ALUOperation(ID_EX_ALUOperation),
    .ID_EX_WriteRegAddr(ID_EX_WriteRegAddr),
    
    .ID_EX_Bubble(ID_EX_Bubble),

    .EX_MEM_IR(EX_MEM_IR),
    .EX_MEM_ALUOutput(EX_MEM_ALUOutput),
    .EX_MEM_B(EX_MEM_B),
    .EX_MEM_Cond(EX_MEM_Cond),
    .EX_MEM_Opcode(EX_MEM_Opcode),
    .EX_MEM_WriteRegAddr(EX_MEM_WriteRegAddr),
    .EX_MEM_WriteMem(EX_MEM_WriteMem),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_Bubble(EX_MEM_Bubble)
);

// MEM
MemoryStage s3(
    .clk(clk),
    .rst(rst),
    
    .EX_MEM_IR(EX_MEM_IR),
    .EX_MEM_ALUOutput(EX_MEM_ALUOutput),
    .EX_MEM_B(EX_MEM_B),
    .EX_MEM_Cond(EX_MEM_Cond),
    .EX_MEM_Opcode(EX_MEM_Opcode),
    .EX_MEM_WriteRegAddr(EX_MEM_WriteRegAddr),
    .EX_MEM_WriteMem(EX_MEM_WriteMem),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_Bubble(EX_MEM_Bubble),

    .MEM_WB_IR(MEM_WB_IR),
    .MEM_WB_WriteRegAddr(MEM_WB_WriteRegAddr),
    .MEM_WB_WriteReg(MEM_WB_WriteReg),
    .MEM_WB_WriteData(MEM_WB_WriteData)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PC <= 0;
    end else begin
        if (stall) begin
            PC = PC;
        end else begin
            PC = PC + 1;
        end
    end
end

endmodule
