`timescale 1ns / 1ps

module ALU(
    input wire [31: 0] A,
    input wire [31: 0] B,
    input wire [3: 0] ALUOperation,
    output reg [31: 0] result,
    output wire zero
);

    wire [31: 0] result_and, result_or, result_add, result_xor, result_nor;
    wire [31: 0] result_sltu, result_sub, result_slt, result_sll, result_srl;
    wire [31: 0] result_sra;

    assign result_and = A & B;
    assign result_or = A | B;
    assign result_add = A + B;
    assign result_xor = A ^ B;
    assign result_nor = ~(A | B);
    assign result_sltu = (A < B) ? 32'b1 : 32'b0;
    assign result_sub = A - B;
    assign result_slt = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
    assign result_sll = B << A;
    assign result_srl = B >> A;
    assign result_sra = B >>> A;
    
    assign zero = result == 32'b0;

    always @* begin
        case (ALUOperation)
            4'd0:
                result = result_and;
            4'd1:
                result = result_or;
            4'd2:
                result = result_add;
            4'd3:
                result = result_xor;
            4'd4:
                result = result_nor;
            4'd5:
                result = result_sltu;
            4'd6:
                result = result_sub;
            4'd7:
                result = result_slt;
            4'd8:
                result = result_sll;
            4'd9:
                result = result_srl;
            4'd10:
                result = result_sra;
        endcase
    end

endmodule
