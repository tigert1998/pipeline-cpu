`timescale 1ns / 1ps

module StallControl(
    input wire rs_used,
    input wire [4: 0] rs,
    input wire rt_used,
    input wire [4: 0] rt,
    
    input wire ID_EX_WriteReg,
    input wire [4: 0] ID_EX_WriteRegAddr,
    input wire ID_EX_Bubble,
    
    input wire EX_MEM_WriteReg,
    input wire [4: 0] EX_MEM_WriteRegAddr,
    input wire EX_MEM_Bubble,
    
    output wire stall
);

wire test_ID_EX, test_EX_MEM;
assign test_ID_EX = ID_EX_WriteReg && !ID_EX_Bubble;
assign test_EX_MEM = EX_MEM_WriteReg && !EX_MEM_Bubble;

assign stall =
    (rs_used && test_ID_EX && rs == ID_EX_WriteRegAddr) ||
    (rs_used && test_EX_MEM && rs == EX_MEM_WriteRegAddr) ||
    (rt_used && test_ID_EX && rt == ID_EX_WriteRegAddr) ||
    (rt_used && test_EX_MEM && rt == EX_MEM_WriteRegAddr);

endmodule
