`timescale 1ns / 1ps

module TestALU(

);

wire [31: 0] result;
wire zero;
reg [3: 0] ALUOperation;
reg [31: 0] A, B;
wire [31: 0] C;

ALU a0(
    .A(A),
    .B(B),
    .ALUOperation(ALUOperation),
    .result(result),
    .zero(zero)
);

initial begin
    #10 B <= {2'b11, 30'b0};
    A <= 1'b1;
    ALUOperation <= 4'd10;
end

endmodule
