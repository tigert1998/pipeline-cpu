`timescale 1ns / 1ps

module ControlUnit(
    input wire [31: 0] Instruction,
    
    output wire Branch,
    output wire WriteReg,
    output wire RtAsDestination,
    output wire MemToReg,
    output wire WriteMem,
    output wire ALUSA,
    output wire ALUImm,
    output wire SignExtendImm,
    output wire ReadRs,
    output wire ReadRt,
    output wire GotoSeries,
    output reg [4: 0] InstructionType,
    output reg [3: 0] ALUOperation,
    output wire [4: 0] ShiftAmount
);

wire [5: 0] Opcode, Func;
wire R, SLL, SRL, SRA, SLLV, SRLV, SRAV, JR, ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR, SLT, SLTU;
wire BEQ, BNE, ADDI, ADDIU, SLTI, SLTIU, ANDI, ORI, XORI, LUI, LW, SW;
wire J, JAL;

assign Opcode = Instruction[31: 26];
assign Func = Instruction[5: 0];
assign ShiftAmount = LUI ? 5'd16 : Instruction[10: 6];

assign R = Opcode == 6'b00_0000;
assign SLL = R && Func == 6'b00_0000;
assign SRL = R && Func == 6'b00_0010;
assign SRA = R && Func == 6'b00_0011;
assign SLLV = R && Func == 6'b00_0100;
assign SRLV = R && Func == 6'b00_0110;
assign SRAV = R && Func == 6'b00_0111;
assign JR = R && Func == 6'b00_1000;
assign ADD = R && Func == 6'b10_0000;
assign ADDU = R && Func == 6'b10_0001;
assign SUB = R && Func == 6'b10_0010;
assign SUBU = R && Func == 6'b10_0011;
assign AND = R && Func == 6'b10_0100;
assign OR = R && Func == 6'b10_0101;
assign XOR = R && Func == 6'b10_0110;
assign NOR = R && Func == 6'b10_0111;
assign SLT = R && Func == 6'b10_1010;
assign SLTU = R && Func == 6'b10_1011;

assign BEQ = Opcode == 6'b00_0100;
assign BNE = Opcode == 6'b00_0101;
assign ADDI = Opcode == 6'b00_1000;
assign ADDIU = Opcode == 6'b00_1001;
assign SLTI = Opcode == 6'b00_1010;
assign SLTIU = Opcode == 6'b00_1011;
assign ANDI = Opcode == 6'b00_1100;
assign ORI = Opcode == 6'b00_1101;
assign XORI = Opcode == 6'b00_1110;
assign LUI = Opcode == 6'b00_1111; 
assign LW = Opcode == 6'b10_0011;
assign SW = Opcode == 6'b10_1011;

assign J = Opcode == 6'b00_0010;
assign JAL = Opcode == 6'b00_0011;

assign Branch = BEQ || BNE;
assign WriteReg =
    SLL || SRL || SRA || SLLV || SRLV || SRAV || ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || SLT || SLTU ||
    ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW || JAL;
assign RtAsDestination = ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW;
assign MemToReg = LW;
assign WriteMem = SW;
assign ALUSA = SLL || SRL || SRA || LUI;
assign ALUImm = ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW || SW;
assign SignExtendImm = ADDI || ADDIU || SLTI || LW || SW;
assign ReadRs =
    SLLV || SRLV || SRAV || JR || ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || SLT || SLTU ||
    BEQ || BNE || ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LW || SW;
assign ReadRt =
    SLL || SRL || SRA || SLLV || SRLV || SRAV || ADD || ADDU || SUB || SUBU || AND || OR || XOR || NOR || SLT || SLTU ||
    BEQ || BNE || SW;
assign GotoSeries = JR || J || JAL;

always @* begin
    if (AND || ANDI) begin
        ALUOperation = 4'd0;
    end else if (OR || ORI) begin
        ALUOperation = 4'd1;
    end else if (ADD || ADDU || ADDI || ADDIU || LW || SW) begin
        ALUOperation = 4'd2;
    end else if (XOR || XORI) begin
        ALUOperation = 4'd3;
    end else if (NOR) begin
        ALUOperation = 4'd4;
    end else if (SLTU || SLTIU) begin
        ALUOperation = 4'd5;
    end else if (SUB || SUBU || BEQ || BNE) begin
        ALUOperation = 4'd6;
    end else if (SLT || SLTI) begin
        ALUOperation = 4'd7;
    end else if (SLL || SLLV || LUI) begin
        ALUOperation = 4'd8;
    end else if (SRL || SRLV) begin
        ALUOperation = 4'd9;
    end else if (SRA || SRAV) begin
        ALUOperation = 4'd10;
    end else begin
        ALUOperation = 4'dx;
    end
end

always @* begin
    if (SLL) begin
        InstructionType <= 5'd0;
    end else if (SRL) begin
        InstructionType <= 5'd1;
    end else if (SRA) begin
        InstructionType <= 5'd2;
    end else if (SLLV) begin
        InstructionType <= 5'd3;
    end else if (SRLV) begin
        InstructionType <= 5'd4;
    end else if (SRAV) begin
        InstructionType <= 5'd5;
    end else if (JR) begin
        InstructionType <= 5'd6;
    end else if (ADD) begin
        InstructionType <= 5'd7;
    end else if (ADDU) begin
        InstructionType <= 5'd8;
    end else if (SUB) begin
        InstructionType <= 5'd9;
    end else if (SUBU) begin
        InstructionType <= 5'd10;
    end else if (AND) begin
        InstructionType <= 5'd11;
    end else if (OR) begin
        InstructionType <= 5'd12;
    end else if (XOR) begin
        InstructionType <= 5'd13;
    end else if (NOR) begin
        InstructionType <= 5'd14;
    end else if (SLT) begin
        InstructionType <= 5'd15;
    end else if (SLTU) begin
        InstructionType <= 5'd16;
    end else if (BEQ) begin
        InstructionType <= 5'd17;
    end else if (BNE) begin
        InstructionType <= 5'd18;
    end else if (ADDI) begin
        InstructionType <= 5'd19;
    end else if (ADDIU) begin
        InstructionType <= 5'd20;
    end else if (SLTI) begin
        InstructionType <= 5'd21;
    end else if (SLTIU) begin
        InstructionType <= 5'd22;
    end else if (ANDI) begin
        InstructionType <= 5'd23;
    end else if (ORI) begin
        InstructionType <= 5'd24;
    end else if (XORI) begin
        InstructionType <= 5'd25;
    end else if (LUI) begin
        InstructionType <= 5'd26;
    end else if (LW) begin
        InstructionType <= 5'd27;
    end else if (SW) begin
        InstructionType <= 5'd28;
    end else if (J) begin
        InstructionType <= 5'd29;
    end else if (JAL) begin
        InstructionType <= 5'd30;
    end
end

endmodule
