`timescale 1ns / 1ps

module StallControl(
    input wire ReadRs,
    input wire [4: 0] rs,
    input wire ReadRt,
    input wire [4: 0] rt,
    
    input wire ID_EX_GotoSeries,
    input wire ID_EX_WriteReg,
    input wire [4: 0] ID_EX_WriteRegAddr,
    input wire ID_EX_Bubble,
    
    input wire EX_MEM_GotoSeries,
    input wire EX_MEM_WriteReg,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_Bubble,
    
    output wire stall
);

wire test_RAW_ID_EX, test_RAW_EX_MEM;
assign test_RAW_ID_EX = !ID_EX_Bubble && ID_EX_WriteReg;
assign test_RAW_EX_MEM = !EX_MEM_Bubble && EX_MEM_WriteReg;

wire test_GotoSeries_ID_EX, test_GotoSeries_EX_MEM;
assign test_GotoSeries_ID_EX = !ID_EX_Bubble && ID_EX_GotoSeries;
assign test_GotoSeries_EX_MEM = !EX_MEM_Bubble && EX_MEM_GotoSeries;

assign stall =
    (ReadRs && test_RAW_ID_EX && rs == ID_EX_WriteRegAddr) ||
    (ReadRs && test_RAW_EX_MEM && rs == EX_MEM_WriteRegAddr) ||
    (ReadRt && test_RAW_ID_EX && rt == ID_EX_WriteRegAddr) ||
    (ReadRt && test_RAW_EX_MEM && rt == EX_MEM_WriteRegAddr) ||
    test_GotoSeries_ID_EX ||
    test_GotoSeries_EX_MEM;

endmodule
