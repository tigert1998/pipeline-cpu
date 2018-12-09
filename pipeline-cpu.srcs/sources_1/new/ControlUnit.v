`timescale 1ns / 1ps

module ControlUnit(
    input wire [31: 0] Instruction,
    
    output wire Branch,
    output wire WriteReg,
    output wire Regrt,
    output wire MemToReg,
    output wire WriteMem,
    output wire ALUSA,
    output wire ALUImm,
    output wire SignExtendImm,
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
    ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW;
assign Regrt = ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW;
assign MemToReg = LW;
assign WriteMem = SW;
assign ALUSA = SLL || SRL || SRA || LUI;
assign ALUImm = ADDI || ADDIU || SLTI || SLTIU || ANDI || ORI || XORI || LUI || LW || SW;
assign SignExtendImm = ADDI || ADDIU || SLTI || LW || SW;

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

endmodule
