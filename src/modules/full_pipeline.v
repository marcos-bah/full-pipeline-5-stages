module full_pipeline(
    input  wire clk,
    input  wire reset
);
    wire [31:0] PC, PCNext, PCPlus4, InstrIF;

    reg  [31:0] IF_ID_PC, IF_ID_Instr;

    wire [6:0]  ID_opcode = IF_ID_Instr[6:0];
    wire [4:0]  ID_rs1    = IF_ID_Instr[19:15];
    wire [4:0]  ID_rs2    = IF_ID_Instr[24:20];
    wire [4:0]  ID_rd     = IF_ID_Instr[11:7];
    wire [2:0]  ID_funct3 = IF_ID_Instr[14:12];
    wire        ID_funct7_5 = IF_ID_Instr[30];

    wire [1:0]  ID_ALUOp;
    wire [1:0]  ID_ImmSrc;
    wire [1:0]  ID_ResultSrc;
    wire        ID_ALUSrc, ID_MemWrite, ID_RegWrite, ID_Branch;

    wire [31:0] RF_RD1, RF_RD2;
    wire [31:0] ID_ImmExt;

    reg  [31:0] ID_EX_PC, ID_EX_SrcA, ID_EX_SrcB, ID_EX_Imm;
    reg  [4:0]  ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
    reg  [2:0]  ID_EX_funct3;
    reg         ID_EX_funct7_5;
    reg         ID_EX_ALUSrc, ID_EX_MemWrite, ID_EX_RegWrite, ID_EX_Branch;
    reg  [1:0]  ID_EX_ALUOp, ID_EX_ResultSrc;

    wire [2:0]  EX_ALUControl;
    wire [31:0] EX_SrcB, EX_ALUResult;
    wire        EX_Zero;
    wire [31:0] EX_BranchTarget;
    wire        EX_BranchTaken;

    reg  [31:0] EX_MEM_ALUResult, EX_MEM_WriteData, EX_MEM_BranchTarget;
    reg  [4:0]  EX_MEM_rd;
    reg         EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_BranchTaken;
    reg  [1:0]  EX_MEM_ResultSrc;

    wire [31:0] MEM_ReadData;
    reg  [31:0] MEM_WB_ReadData, MEM_WB_ALUResult;
    reg  [4:0]  MEM_WB_rd;
    reg         MEM_WB_RegWrite;
    reg  [1:0]  MEM_WB_ResultSrc;

    wire [31:0] WB_Result;
    assign WB_Result = (MEM_WB_ResultSrc == 2'b01) ? MEM_WB_ReadData : MEM_WB_ALUResult;

    pc pc_reg(.clk(clk), .reset(reset), .PCNext(PCNext), .PC(PC));
    instruction_memory imem(.A(PC), .RD(InstrIF));

    main_decoder md(.op(ID_opcode),
        .RegWrite(ID_RegWrite),
        .ImmSrc(ID_ImmSrc),
        .ALUSrc(ID_ALUSrc),
        .MemWrite(ID_MemWrite),
        .ResultSrc(ID_ResultSrc),
        .Branch(ID_Branch),
        .ALUOp(ID_ALUOp)
    );

    register_file rf(.clk(clk), .reset(reset), .WE3(MEM_WB_RegWrite), .A1(ID_rs1), .A2(ID_rs2), .A3(MEM_WB_rd), .WD3(WB_Result), .RD1(RF_RD1), .RD2(RF_RD2));

    extend immgen(.Instr(IF_ID_Instr[31:7]), .ImmSrc(ID_ImmSrc), .ImmExt(ID_ImmExt));

    alu_decoder ad(.ALUOp(ID_EX_ALUOp), .funct3(ID_EX_funct3), .funct7b5(ID_EX_funct7_5), .ALUControl(EX_ALUControl));

    alu alu_unit(.SrcA(ID_EX_SrcA), .SrcB(EX_SrcB), .ALUControl(EX_ALUControl), .ALUResult(EX_ALUResult), .Zero(EX_Zero));

    data_memory dmem(.clk(clk), .MemWrite(EX_MEM_MemWrite), .A(EX_MEM_ALUResult), .WD(EX_MEM_WriteData), .RD(MEM_ReadData));

    assign PCPlus4 = PC + 32'd4;
    assign EX_BranchTarget = ID_EX_PC + ID_EX_Imm;
    assign EX_BranchTaken = ID_EX_Branch & EX_Zero;

    assign PCNext = EX_BranchTaken ? EX_BranchTarget : PCPlus4;

    assign EX_SrcB = ID_EX_ALUSrc ? ID_EX_Imm : ID_EX_SrcB;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_PC <= 32'd0;
            IF_ID_Instr <= 32'd0;
        end else begin
            IF_ID_PC <= PC;
            IF_ID_Instr <= InstrIF;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_EX_PC <= 0; ID_EX_SrcA <= 0; ID_EX_SrcB <= 0; ID_EX_Imm <= 0;
            ID_EX_rs1 <= 0; ID_EX_rs2 <= 0; ID_EX_rd <= 0; ID_EX_funct3 <= 0; ID_EX_funct7_5 <= 0;
            ID_EX_ALUSrc <= 0; ID_EX_MemWrite <= 0; ID_EX_RegWrite <= 0; ID_EX_Branch <= 0;
            ID_EX_ALUOp <= 0; ID_EX_ResultSrc <= 0;
        end else begin
            ID_EX_PC <= IF_ID_PC;
            ID_EX_SrcA <= RF_RD1;
            ID_EX_SrcB <= RF_RD2;
            ID_EX_Imm <= ID_ImmExt;
            ID_EX_rs1 <= ID_rs1;
            ID_EX_rs2 <= ID_rs2;
            ID_EX_rd <= ID_rd;
            ID_EX_funct3 <= ID_funct3;
            ID_EX_funct7_5 <= ID_funct7_5;
            ID_EX_ALUSrc <= ID_ALUSrc;
            ID_EX_MemWrite <= ID_MemWrite;
            ID_EX_RegWrite <= ID_RegWrite;
            ID_EX_Branch <= ID_Branch;
            ID_EX_ALUOp <= ID_ALUOp;
            ID_EX_ResultSrc <= ID_ResultSrc;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_MEM_ALUResult <= 0; EX_MEM_WriteData <= 0; EX_MEM_rd <= 0; EX_MEM_MemWrite <= 0; EX_MEM_RegWrite <= 0; EX_MEM_ResultSrc <= 0; EX_MEM_BranchTaken <= 0; EX_MEM_BranchTarget <= 0;
        end else begin
            EX_MEM_ALUResult <= EX_ALUResult;
            EX_MEM_WriteData <= ID_EX_SrcB;
            EX_MEM_rd <= ID_EX_rd;
            EX_MEM_MemWrite <= ID_EX_MemWrite;
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_ResultSrc <= ID_EX_ResultSrc;
            EX_MEM_BranchTaken <= EX_BranchTaken;
            EX_MEM_BranchTarget <= EX_BranchTarget;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_WB_ReadData <= 0; MEM_WB_ALUResult <= 0; MEM_WB_rd <= 0; MEM_WB_RegWrite <= 0; MEM_WB_ResultSrc <= 0;
        end else begin
            MEM_WB_ReadData <= MEM_ReadData;
            MEM_WB_ALUResult <= EX_MEM_ALUResult;
            MEM_WB_rd <= EX_MEM_rd;
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_ResultSrc <= EX_MEM_ResultSrc;
        end
    end

    always @(*) begin
        MEM_WB_RegWrite = MEM_WB_RegWrite; 
    end

endmodule