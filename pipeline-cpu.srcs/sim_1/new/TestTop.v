`timescale 1ns / 1ps

module TestTop();

integer i;

reg clk, rst;
Top t0(
    .clk(clk),
    .rst(rst)
);

initial begin
    rst = 0;
    clk = 1;
    #10 rst = 1;
    #10 rst = 0; 
    
    forever begin
        #10 clk = ~clk;
    end

end

endmodule
