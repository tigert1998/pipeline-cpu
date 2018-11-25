`timescale 1ns / 1ps

module Registers(
    input wire clk,
    input wire rst,
    input wire RegWrite,
    input wire [4: 0] ReadRegAddr1,
    input wire [4: 0] ReadRegAddr2,
    input wire [4: 0] ReadRegAddr3,
    input wire [4: 0] WriteRegAddr,
    input wire [31: 0] WriteData,
    output wire [31: 0] ReadData1,
    output wire [31: 0] ReadData2,
    output wire [31: 0] ReadData3
);

    integer i;
    reg [31: 0] registers[0: 31];
    
    assign ReadData1 = ReadRegAddr1 == 5'd0 ? 32'd0 : registers[ReadRegAddr1];
    assign ReadData2 = ReadRegAddr2 == 5'd0 ? 32'd0 : registers[ReadRegAddr2];
    assign ReadData3 = ReadRegAddr3 == 5'd0 ? 32'd0 : registers[ReadRegAddr3];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i <= 5'd31; i = i + 1) begin
                registers[i] = 32'd0;
            end
        end else if (clk) begin
            if (RegWrite)
                registers[WriteRegAddr] = WriteData;
        end
    end

endmodule
