
/*
 * MÓDULO TOP (ESTRUTURAL) - v3 (Corrigido)
 * -----------------------
 * Módulo top (o usuário chama de single_cycle_cpu.v)
 * Padronizado para usar 'rst' e nomes corretos de módulos.
 */
module single_cycle_cpu(
    input  wire clk,
    input  wire rst // <-- CORRIGIDO: Padronizado para 'rst'
);
// =================================================================
    // --- Sinais (Wires) ---
    // =================================================================

    // --- Estágio IF (Fetch) ---
    wire [31:0] PC_IF, PCNext_IF, PCPlus4_IF, Instr_IF;
    
    // --- Estágio ID (Decode) ---
    wire [31:0] PC_ID, PCPlus4_ID, Instr_ID;
    wire [31:0] RF_RD1_ID, RF_RD2_ID, ImmExt_ID;
    wire [1:0]  ALUOp_ID, ImmSrc_ID, ResultSrc_ID;
    wire        ALUSrc_ID, MemWrite_ID, RegWrite_ID, Branch_ID;
    wire [6:0]  Opcode_ID = Instr_ID[6:0];
    wire [4:0]  Rs1_ID    = Instr_ID[19:15];
    wire [4:0]  Rs2_ID    = Instr_ID[24:20];
    wire [4:0]  Rd_ID     = Instr_ID[11:7];
    wire [2:0]  Funct3_ID = Instr_ID[14:12];
    wire        Funct7_5_ID = Instr_ID[30];
    
    // Sinais de depuração do Register File
    wire [31:0] t0, t1, t2, t3;

    // --- Estágio EX (Execute) ---
    wire [31:0] PC_EX, PCPlus4_EX, SrcA_EX, SrcB_EX, ImmExt_EX;
    wire [31:0] SrcB_Mux_EX; 
    wire [4:0]  Rd_EX;
    wire [2:0]  Funct3_EX;
    wire        Funct7_5_EX;
    wire [1:0]  ALUOp_EX, ResultSrc_EX;
    wire        ALUSrc_EX, MemWrite_EX, RegWrite_EX, Branch_EX;
    wire [3:0]  ALUControl_EX;
    wire [31:0] ALUResult_EX;
    wire        Zero_EX;
    wire [31:0] BranchTarget_EX;
    wire        BranchTaken_EX;

    // --- Estágio MEM (Memory) ---
    wire [31:0] ALUResult_MEM, WriteData_MEM, BranchTarget_MEM, PCPlus4_MEM;
    wire [4:0]  Rd_MEM;
    wire [1:0]  ResultSrc_MEM;
    wire        MemWrite_MEM, RegWrite_MEM, BranchTaken_MEM;
    wire [31:0] ReadData_MEM;

    // --- Estágio WB (Write Back) ---
    wire [31:0] ALUResult_WB, ReadData_WB, PCPlus4_WB;
    wire [4:0]  Rd_WB;
    wire [1:0]  ResultSrc_WB;
    wire        RegWrite_WB;
    wire [31:0] Result_WB;


    // =================================================================
    // Estágio IF (Instruction Fetch)
    // =================================================================

    assign PCNext_IF = BranchTaken_MEM ? BranchTarget_MEM : PCPlus4_IF;

    pc pc_reg (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .PCNext(PCNext_IF),
        .PC(PC_IF)
    );

    adder pc_plus_4 (
        .a(PC_IF),
        .b(32'd4),
        .y(PCPlus4_IF)
    );

    instruction_memory imem (
        .A(PC_IF),
        .RD(Instr_IF)
    );

    // =================================================================
    // Registrador de Pipeline IF/ID
    // =================================================================
    reg_if_id if_id_pipe (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .en(1'b1),    // Sem stall, por enquanto
        .flush(1'b0), // Sem flush, por enquanto
        .PC_in(PC_IF),
        .PCPlus4_in(PCPlus4_IF),
        .Instr_in(Instr_IF),
        .PC_out(PC_ID),
        .PCPlus4_out(PCPlus4_ID),
        .Instr_out(Instr_ID)
    );

    // =================================================================
    // Estágio ID (Instruction Decode)
    // =================================================================

    main_decoder decoder (
        .op(Opcode_ID),
        .RegWrite(RegWrite_ID),
        .ImmSrc(ImmSrc_ID),
        .ALUSrc(ALUSrc_ID),
        .MemWrite(MemWrite_ID),
        .ResultSrc(ResultSrc_ID),
        .Branch(Branch_ID),
        .ALUOp(ALUOp_ID)
    );

    register_file rf (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .WE3(RegWrite_WB),  
        .A1(Rs1_ID),        
        .A2(Rs2_ID),        
        .A3(Rd_WB),         
        .WD3(Result_WB),    
        .RD1(RF_RD1_ID),
        .RD2(RF_RD2_ID),
        // Conectando saídas de depuração
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .t3(t3)
    );

    extend imm_gen (
        .Instr(Instr_ID[31:7]),
        .ImmSrc(ImmSrc_ID),
        .ImmExt(ImmExt_ID)
    );

    // =================================================================
    // Registrador de Pipeline ID/EX
    // =================================================================
    reg_id_ex id_ex_pipe (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .en(1'b1),    // Sem stall
        .flush(1'b0), // Sem flush
        
        // Dados
        .PC_in(PC_ID),
        .PCPlus4_in(PCPlus4_ID),
        .SrcA_in(RF_RD1_ID),
        .SrcB_in(RF_RD2_ID),
        .ImmExt_in(ImmExt_ID),
        .Rd_in(Rd_ID),
        .Funct3_in(Funct3_ID),
        .Funct7_5_in(Funct7_5_ID),
        
        // Controle
        .ALUOp_in(ALUOp_ID),
        .ALUSrc_in(ALUSrc_ID),
        .MemWrite_in(MemWrite_ID),
        .RegWrite_in(RegWrite_ID),
        .Branch_in(Branch_ID),
        .ResultSrc_in(ResultSrc_ID),
        
        // Saídas...
        .PC_out(PC_EX),
        .PCPlus4_out(PCPlus4_EX),
        .SrcA_out(SrcA_EX),
        .SrcB_out(SrcB_EX),
        .ImmExt_out(ImmExt_EX),
        .Rd_out(Rd_EX),
        .Funct3_out(Funct3_EX),
        .Funct7_5_out(Funct7_5_EX),
        
        .ALUOp_out(ALUOp_EX),
        .ALUSrc_out(ALUSrc_EX),
        .MemWrite_out(MemWrite_EX),
        .RegWrite_out(RegWrite_EX),
        .Branch_out(Branch_EX),
        .ResultSrc_out(ResultSrc_EX)
    );

    // =================================================================
    // Estágio EX (Execute)
    // =================================================================

    alu_decoder alu_dec (
        .ALUOp(ALUOp_EX),
        .funct3(Funct3_EX),
        .funct7b5(Funct7_5_EX),
        .ALUControl(ALUControl_EX)
    );

    // O mux 2-para-1 que você forneceu (mux.v)
    mux2_1 alu_src_mux ( // <-- CORRIGIDO (nome do módulo)
        .in0(SrcB_EX),    
        .in1(ImmExt_EX),  
        .sel(ALUSrc_EX),
        .d(SrcB_Mux_EX)
    );

    alu alu_unit (
        .SrcA(SrcA_EX),
        .SrcB(SrcB_Mux_EX),
        .ALUControl(ALUControl_EX),
        .ALUResult(ALUResult_EX),
        .Zero(Zero_EX)
    );

    adder branch_target_adder (
        .a(PC_EX),
        .b(ImmExt_EX),
        .y(BranchTarget_EX)
    );

    assign BranchTaken_EX = Branch_EX & Zero_EX;

    // =================================================================
    // Registrador de Pipeline EX/MEM
    // =================================================================
    reg_ex_mem ex_mem_pipe (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .en(1'b1),    // Sem stall
        .flush(1'b0), // Sem flush
        
        .ALUResult_in(ALUResult_EX),
        .WriteData_in(SrcB_EX), 
        .BranchTarget_in(BranchTarget_EX),
        .PCPlus4_in(PCPlus4_EX),
        .Rd_in(Rd_EX),
        
        .MemWrite_in(MemWrite_EX),
        .RegWrite_in(RegWrite_EX),
        .BranchTaken_in(BranchTaken_EX),
        .ResultSrc_in(ResultSrc_EX),
        
        .ALUResult_out(ALUResult_MEM),
        .WriteData_out(WriteData_MEM),
        .BranchTarget_out(BranchTarget_MEM),
        .PCPlus4_out(PCPlus4_MEM),
        .Rd_out(Rd_MEM),
        
        .MemWrite_out(MemWrite_MEM),
        .RegWrite_out(RegWrite_MEM),
        .BranchTaken_out(BranchTaken_MEM),
        .ResultSrc_out(ResultSrc_MEM)
    );

    // =================================================================
    // Estágio MEM (Memory)
    // =================================================================

    data_memory dmem (
        .clk(clk),
        .MemWrite(MemWrite_MEM),
        .A(ALUResult_MEM),  
        .WD(WriteData_MEM), 
        .RD(ReadData_MEM)   
    );

    // =================================================================
    // Registrador de Pipeline MEM/WB
    // =================================================================
    reg_mem_wb mem_wb_pipe (
        .clk(clk),
        .rst(rst), // <-- CORRIGIDO
        .en(1'b1),    // Sem stall
        .flush(1'b0), // Sem flush
        
        .ALUResult_in(ALUResult_MEM),
        .ReadData_in(ReadData_MEM),
        .PCPlus4_in(PCPlus4_MEM),
        .Rd_in(Rd_MEM),
        
        .RegWrite_in(RegWrite_MEM),
        .ResultSrc_in(ResultSrc_MEM),
        
        .ALUResult_out(ALUResult_WB),
        .ReadData_out(ReadData_WB),
        .PCPlus4_out(PCPlus4_WB),
        .Rd_out(Rd_WB),
        
        .RegWrite_out(RegWrite_WB),
        .ResultSrc_out(ResultSrc_WB)
    );

    // =================================================================
    // Estágio WB (Write Back)
    // =================================================================

    mux3_1 wb_mux (
        .in_0(ALUResult_WB), 
        .in_1(ReadData_WB),   
        .in_2(PCPlus4_WB),    
        .sel(ResultSrc_WB),
        .y(Result_WB)
    );

endmodule