module single_cycle_cpu (
    input wire clk,
    input wire reset
);
    wire [31:0] PC, PCNext, PCPlus4, PCTarget;
    wire [31:0] Instr;
    wire [31:0] ImmExt;
    wire [31:0] SrcA, SrcB, ALUResult, ReadData, Result;
    wire Zero, PCSrc, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ResultSrc, ImmSrc;
    wire [2:0] ALUControl;

    // ===== Program Counter =====
    pc pc_reg (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    // ===== Instruction Memory =====
    instruction_memory imem (
        .A(PC),
        .RD(Instr)
    );

    // ===== Control Unit =====
    control_unit control (
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .Zero(Zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl)
    );

    // ===== Register File =====
    register_file rf (
        .clk(clk),
        .reset(reset),
        .WE3(RegWrite),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WD3(Result),
        .RD1(SrcA),
        .RD2(SrcB)
    );

    // ===== Immediate Generator =====
    extend immext (
        .Instr(Instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // ===== ALU Source MUX =====
    wire [31:0] SrcBFinal = ALUSrc ? ImmExt : SrcB;

    // ===== ALU =====
    alu alu_unit (
        .SrcA(SrcA),
        .SrcB(SrcBFinal),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // ===== Data Memory =====
    data_memory dmem (
        .clk(clk),
        .MemWrite(MemWrite),
        .A(ALUResult),
        .WD(SrcB),
        .RD(ReadData)
    );

    // ===== Result MUX =====
    assign Result = (ResultSrc == 2'b00) ? ALUResult :
                    (ResultSrc == 2'b01) ? ReadData :
                                           PCPlus4;

    // ===== Next PC logic =====
    assign PCPlus4 = PC + 4;
    assign PCTarget = PC + ImmExt;
    assign PCNext = PCSrc ? PCTarget : PCPlus4;

endmodule
