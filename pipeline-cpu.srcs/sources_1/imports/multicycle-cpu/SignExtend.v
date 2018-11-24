`timescale 1ns / 1ps

module SignExtend(
    input wire [15: 0] i,
    output wire [31: 0] o
);

    assign o = {{16{i[15]}}, i[15: 0]};

endmodule
