`timescale 1ns / 1ps

module StallControl(
    input wire ReadRs,
    input wire [4: 0] rs,
    input wire ReadRt,
    input wire [4: 0] rt,
    
    input wire ID_EX_GotoSeries,
    input wire ID_EX_BranchTaken,
    input wire ID_EX_WriteReg,
    input wire ID_EX_MemToReg,
    input wire [4: 0] ID_EX_WriteRegAddr,
    input wire ID_EX_Bubble,
    
    input wire EX_MEM_GotoSeries,
    input wire EX_MEM_BranchTaken,
    input wire EX_MEM_Bubble,
    
    output wire stall
);

wire test_RAW_ID_EX;
assign test_RAW_ID_EX = !ID_EX_Bubble && ID_EX_WriteReg && ID_EX_MemToReg;

wire test_GotoSeries_ID_EX, test_GotoSeries_EX_MEM;
assign test_GotoSeries_ID_EX = !ID_EX_Bubble && (ID_EX_GotoSeries || ID_EX_BranchTaken);
assign test_GotoSeries_EX_MEM = !EX_MEM_Bubble && (EX_MEM_GotoSeries || EX_MEM_BranchTaken);

assign stall =
    test_GotoSeries_ID_EX ||
    test_GotoSeries_EX_MEM ||
    (test_RAW_ID_EX && ReadRs && ID_EX_WriteRegAddr == rs) ||
    (test_RAW_ID_EX && ReadRt && ID_EX_WriteRegAddr == rt);

endmodule
