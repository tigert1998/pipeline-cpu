`timescale 1ns / 1ps

module InstructionDecodeStage(
    input wire rst,
    input wire clk,
    // input pipeline registers
    input wire [31: 0] IF_ID_IR,
    input wire [31: 0] IF_ID_NPC,
    input wire IF_ID_Bubble,
    
    // input pipeline registers and special wires from other stages
    input wire EX_MEM_GotoSeries,
    input wire EX_MEM_BranchTaken,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_WriteReg,
    input wire EX_MEM_MemToReg,
    input wire EX_MEM_Bubble,
    // ALU output
    input wire [31: 0] ALUOutput,
    
    input wire MEM_WB_GotoSeries,
    input wire MEM_WB_BranchTaken,
    input wire [4: 0] MEM_WB_WriteRegAddr,
    input wire MEM_WB_WriteReg,
    input wire [31: 0] MEM_WB_WriteData,
    // memory output
    input wire [31: 0] WriteData,

    // output pipeline registers
    output reg [31: 0] ID_EX_A,
    output reg [31: 0] ID_EX_B,
    output reg [31: 0] ID_EX_NPC,
    output reg [31: 0] ID_EX_IR,
    output reg [31: 0] ID_EX_Imm,
    output reg [4: 0] ID_EX_ShiftAmount,
    
    output reg ID_EX_JAL,
    output reg [31: 0] ID_EX_JAL_WriteData,
    output reg ID_EX_WriteReg,
    output reg ID_EX_MemToReg,
    output reg ID_EX_WriteMem,
    output reg ID_EX_ALUSA,
    output reg ID_EX_ALUImm,
    output reg ID_EX_GotoSeries,
    output reg [3: 0] ID_EX_ALUOperation,
    output reg [4: 0] ID_EX_WriteRegAddr,
    output reg ID_EX_BranchTaken,
    
    output reg ID_EX_Bubble,

    // other output
    output wire stall
);

wire Branch, WriteReg, RtAsDestination, MemToReg, WriteMem, ALUSA, ALUImm, SignExtendImm;
wire ReadRs, ReadRt, GotoSeries;
wire [4: 0] InstructionType;
wire [3: 0] ALUOperation;
wire [4: 0] ShiftAmount;

ControlUnit c0(
    .Instruction(IF_ID_IR),
    .Branch(Branch),
    .WriteReg(WriteReg),
    .RtAsDestination(RtAsDestination),
    .MemToReg(MemToReg),
    .WriteMem(WriteMem),
    .ALUSA(ALUSA),
    .ALUImm(ALUImm),
    .SignExtendImm(SignExtendImm),
    .ReadRs(ReadRs),
    .ReadRt(ReadRt),
    .GotoSeries(GotoSeries),
    .InstructionType(InstructionType),
    .ALUOperation(ALUOperation),
    .ShiftAmount(ShiftAmount)
);

wire [31: 0] ReadData1, ReadData2;
Registers r0(
    .clk(~clk),
    .rst(rst),
    .WriteReg(MEM_WB_WriteReg),
    .ReadRegAddr1(IF_ID_IR[25: 21]),
    .ReadRegAddr2(IF_ID_IR[20: 16]),
    .ReadRegAddr3(),
    .WriteRegAddr(MEM_WB_WriteRegAddr),
    .WriteData(MEM_WB_WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .ReadData3()
);

wire [31: 0] SignExtendedImm, ZeroExtendedImm;
SignExtend s0(
    .I(IF_ID_IR[15: 0]),
    .O(SignExtendedImm)
);
ZeroExtend z0(
    .I(IF_ID_IR[15: 0]),
    .O(ZeroExtendedImm)
);

StallControl s1(
    .ReadRs(ReadRs),
    .rs(IF_ID_IR[25: 21]),
    .ReadRt(ReadRt),
    .rt(IF_ID_IR[20: 16]),
    
    .ID_EX_GotoSeries(ID_EX_GotoSeries),
    .ID_EX_BranchTaken(ID_EX_BranchTaken),
    .ID_EX_WriteReg(ID_EX_WriteReg),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_WriteRegAddr(ID_EX_WriteRegAddr),
    .ID_EX_Bubble(ID_EX_Bubble),
    
    .EX_MEM_GotoSeries(EX_MEM_GotoSeries),
    .EX_MEM_BranchTaken(EX_MEM_BranchTaken),
    .EX_MEM_Bubble(EX_MEM_Bubble),
    
    .stall(stall)
);

wire ForwardRs, ForwardRt;
wire [31: 0] rs_data, rt_data;
ForwardControl f0(
    .ReadRs(ReadRs),
    .rs(IF_ID_IR[25: 21]),
    .ReadRt(ReadRt),
    .rt(IF_ID_IR[20: 16]),
    
    .ID_EX_GotoSeries(ID_EX_GotoSeries),
    .ID_EX_BranchTaken(ID_EX_BranchTaken),
    .ID_EX_WriteReg(ID_EX_WriteReg),
    .ID_EX_MemToReg(ID_EX_MemToReg),
    .ID_EX_WriteRegAddr(ID_EX_WriteRegAddr),
    .ID_EX_Bubble(ID_EX_Bubble),
    .ALUOutput(ALUOutput),
    
    .EX_MEM_GotoSeries(EX_MEM_GotoSeries),
    .EX_MEM_BranchTaken(EX_MEM_BranchTaken),
    .EX_MEM_WriteReg(EX_MEM_WriteReg),
    .EX_MEM_MemToReg(EX_MEM_MemToReg),
    .EX_MEM_WriteRegAddr(EX_MEM_WriteRegAddr),
    .EX_MEM_Bubble(EX_MEM_Bubble),
    .WriteData(WriteData),
    
    .ForwardRs(ForwardRs),
    .rs_data(rs_data),
    .ForwardRt(ForwardRt),
    .rt_data(rt_data)
);

wire [31: 0] A, B;
assign A = ForwardRs ? rs_data : ReadData1;
assign B = ForwardRt ? rt_data : ReadData2;

always @(posedge clk or posedge rst) begin
    if (rst || stall || IF_ID_Bubble || MEM_WB_GotoSeries || MEM_WB_BranchTaken) begin
        ID_EX_WriteReg <= 0;
        ID_EX_WriteMem <= 0;
        ID_EX_GotoSeries <= 0;
        ID_EX_BranchTaken <= 0;
        
        ID_EX_Bubble <= 1;
    end else begin
        ID_EX_A <= A;
        ID_EX_B <= B;
        ID_EX_JAL <= InstructionType == 5'd30;
        ID_EX_JAL_WriteData <= IF_ID_NPC;
        
        case (InstructionType)
            5'd6: begin // JR
                ID_EX_NPC <= A;
                ID_EX_BranchTaken <= 0;
            end
            5'd17: begin // BEQ
                ID_EX_NPC <= (A == B) ? IF_ID_NPC + (SignExtendedImm << 2) : IF_ID_NPC;
                ID_EX_BranchTaken <= (A == B);
            end
            5'd18: begin // BNE
                ID_EX_NPC <= (A != B) ? IF_ID_NPC + (SignExtendedImm << 2) : IF_ID_NPC;
                ID_EX_BranchTaken <= (A != B);
            end
            5'd29, 5'd30: begin // J JAL
                ID_EX_NPC <= {IF_ID_NPC[31: 28], IF_ID_IR[25: 0], 2'b00};
                ID_EX_BranchTaken <= 0;
            end
            default: begin
                ID_EX_NPC <= 32'dx;
                ID_EX_BranchTaken <= 0;
            end
        endcase
        
        ID_EX_IR <= IF_ID_IR;
        ID_EX_Imm <= SignExtendImm ? SignExtendedImm : ZeroExtendedImm;
        ID_EX_ShiftAmount <= ShiftAmount;
   
        ID_EX_WriteReg <= WriteReg;
        ID_EX_MemToReg <= MemToReg;
        ID_EX_WriteMem <= WriteMem;
        ID_EX_ALUSA <= ALUSA;
        ID_EX_ALUImm <= ALUImm;
        ID_EX_GotoSeries <= GotoSeries;
        ID_EX_ALUOperation <= ALUOperation;
        ID_EX_WriteRegAddr <=
            (InstructionType == 5'd30) ? 5'd31 :
            (RtAsDestination ? IF_ID_IR[20: 16] : IF_ID_IR[15: 11]);
        
        ID_EX_Bubble <= 0;
    end
end

endmodule
