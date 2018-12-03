`timescale 1ns / 1ps

module ControlUnit(
    input wire [31: 0] instruction,
    
    output wire Branch,
    output wire WriteReg,
    output wire Regrt,
    output wire MemToReg,
    output wire WriteMem,
    output wire ALUImm,
    output reg [2: 0] ALUOperation,
    output wire [4: 0] ShiftAmount
);

wire [5: 0] Opcode, Func;
wire BEQ, BNE, R, LW, SW, ADDI, ANDI, ORI;
assign Opcode = instruction[31: 26];
assign Func = instruction[5: 0];
assign ShiftAmount = instruction[10: 6];

assign R = Opcode == 6'b00_0000;
 
assign BEQ = Opcode == 6'b00_0100;
assign BNE = Opcode == 6'b00_0101;
assign LW = Opcode == 6'b10_0011;
assign SW = Opcode == 6'b10_1011;
assign ADDI = Opcode == 6'b00_1000;
assign ANDI = Opcode == 6'b00_1100;
assign ORI = Opcode == 6'b00_1101;

assign Branch = BEQ || BNE;
assign WriteReg = R || LW || ADDI || ANDI || ORI;
assign Regrt = LW || ADDI || ANDI || ORI;
assign MemToReg = LW;
assign WriteMem = SW;
assign ALUImm = LW || SW || ADDI || ANDI || ORI;

always @* begin
    if (Branch) begin
        ALUOperation = 3'b110; // sub
    end else if (ADDI) begin
        // add
        ALUOperation = 3'b010;
    end else if (ANDI) begin
        // and
        ALUOperation = 3'b000;
    end else if (ORI) begin
        // or
        ALUOperation = 3'b001;
    end else if (R) begin
        case (Func)
            6'b100000: // add
                ALUOperation = 3'b010;
            6'b100010: // sub
                ALUOperation = 3'b110;
            6'b100100: // and
                ALUOperation = 3'b000;
            6'b100101: // or
                ALUOperation = 3'b001;
            6'b100111: // nor
                ALUOperation = 3'b100;
            6'b101010: // slt
                ALUOperation = 3'b111;
        endcase
    end else
        ALUOperation = 3'b010; // add
end

endmodule
