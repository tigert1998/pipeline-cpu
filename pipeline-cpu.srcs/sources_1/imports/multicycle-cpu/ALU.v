`timescale 1ns / 1ps

module ALU(
    input wire [31: 0] A,
    input wire [31: 0] B,
    input wire [2: 0] ALUOperation,
    output wire [31: 0] result,
    output wire zero
);

    wire [31: 0] result_and, result_or, result_add, result_sub, result_nor, result_slt, result_xor, result_srl;

    assign result_and = A & B;
    assign result_or = A | B;
    assign result_add = A + B;
    assign result_sub = A - B;
    assign result_nor = ~(A | B);
    assign result_slt = (A < B) ? 32'b1 : 32'b0;
    assign result_xor = A ^ B;
    assign result_srl = B >> 1;
    assign zero = result == 32'b0;

    assign result = ALUOperation == 3'b000 ? result_and : (
        ALUOperation == 3'b001 ? result_or : (
            ALUOperation == 3'b010 ? result_add : (
                ALUOperation == 3'b011 ? result_xor : (
                    ALUOperation == 3'b100 ? result_nor : (
                        ALUOperation == 3'b101 ? result_srl : (
                            ALUOperation == 3'b110 ? result_sub : result_slt
                        )
                    )
                )
            )
        )
    );

endmodule
