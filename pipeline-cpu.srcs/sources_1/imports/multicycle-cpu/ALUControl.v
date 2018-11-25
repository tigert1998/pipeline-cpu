`timescale 1ns / 1ps

module ALUControl(
    input wire [5: 0] Func,
    input wire [1: 0] ALUOp,
    output reg [2: 0] ALUOperation
);

    wire R, Branch;
    assign {R, Branch} = ALUOp;

    always @* begin
        if (Branch)
            ALUOperation = 3'b110; // sub
        else begin
            if (R) begin
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
    end

endmodule
