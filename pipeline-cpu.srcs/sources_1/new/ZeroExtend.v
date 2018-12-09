`timescale 1ns / 1ps

module ZeroExtend(
    input wire [15: 0] I,
    output wire [31: 0] O
);

assign O = {16'b0, I[15: 0]};

endmodule
