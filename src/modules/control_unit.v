module control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5,
    input Zero,
    output PCSrc,
    output [1:0] ResultSrc,
    output MemWrite,
    output [2:0] ALUControl,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite
);

wire Branch, Jump;
wire [1:0] ALUOp;

main_decoder MD(
    .op(op),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .Jump(Jump)
);

alu_decoder AD(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7b5(funct7b5),
    .ALUControl(ALUControl)
);

assign PCSrc = (Branch & Zero) | Jump;

endmodule
