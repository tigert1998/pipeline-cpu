`timescale 1ns / 1ps

module TestMem();

reg [8: 0] addra;
reg clka, wea;
reg [31: 0] dina;
wire [31: 0] douta;

InstructionMemory m(
    .addra(addra),
    .clka(clka),
    .dina(dina),
    .douta(douta),
    .ena(1),
    .wea(wea)
);

initial begin
    addra = 1;
    clka = 0;
    dina = 10086;
    wea = 1;
    
    #100 clka = 1;
    #100 clka = 0;
    
    wea = 0;
    #100 clka = 1;
end

endmodule
