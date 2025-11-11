module single_cycle_cpu (
    input  wire clk,
    input  wire rst
);

    // controle / sinais entre estágios
    wire        s_PCSrc;
    wire        s_PCSrc_reg;
    wire        s_PCSrc_reg_mem;
    wire        s_ResultSrc;
    wire        s_ResultSrc_reg;
    wire        s_ResultSrc_reg_mem;
    wire        s_MemWrite;
    wire        s_MemWrite_reg;
    wire        s_MemWrite_reg_mem;
    wire [2:0]  s_ALUControl;
    wire [2:0]  s_ALUControl_reg;
    wire [2:0]  s_ALUControl_reg_mem;
    wire        s_ALUSrc;
    wire        s_ALUSrc_reg;
    wire        s_ALUSrc_reg_mem;
    wire [1:0]  s_ImmSrc;
    wire [1:0]  s_ImmSrc_reg;
    wire [1:0]  s_ImmSrc_reg_mem;
    wire        s_RegWrite;
    wire        s_RegWrite_reg;
    wire        s_RegWrite_reg_mem;

    // sinais de branch/jump
    wire        s_branchFlag;
    wire        s_branchFlag_ex;
    wire        s_jumpFlag;
    wire [31:0] s_jumpAddress;
    wire        s_flush_INST_CTRL_ID;

    // instrucoes / PC
    wire [31:0] s_Instr;
    wire [31:0] s_Instr_reg;
    wire [4:0]  s_Instr_ctrl_idex;
    wire [4:0]  s_Instr_ctrl_memwb;
    wire [31:0] s_PC;
    wire [31:0] s_PC_Target;

    // dados / ALU / memoria
    wire [31:0] s_ImmExt;
    wire [31:0] s_ImmExt_reg;
    wire [31:0] s_WriteData;
    wire [31:0] s_SrcA;
    wire [31:0] s_RD1_reg;
    wire [31:0] s_RD2_reg;
    wire [31:0] s_SrcB;
    wire        s_Zero;
    wire [31:0] s_ALUResult;
    wire [31:0] s_ALUResult_reg;
    wire [31:0] s_ReadData;
    wire [31:0] s_ReadData_reg;
    wire [31:0] s_Result;

    wire [2:0]  s_funct3_idex;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 5;
    localparam REG_COUNT  = 32;

    // program counter
    pc programCounter (
        .clk(clk),
        .rst(rst),
        .branchFlag(s_branchFlag),
        .zeroFlag(s_Zero),
        .jumpFlag(s_jumpFlag),
        .jumpAddress(s_jumpAddress),
        .branchOffset(s_ImmExt),
        .PC(s_PC),
        .flush_INST_CTRL_ID(s_flush_INST_CTRL_ID)
    );

    // instruction memory -> pipeline reg
    instruction_memory instMem (
        .A(s_PC),
        .RD(s_Instr_reg)
    );

    register #(.N(DATA_WIDTH)) reg_INST (
        .clk(clk),
        .rst(rst | s_flush_INST_CTRL_ID),
        .d(s_Instr_reg),
        .q(s_Instr)
    );

    // register file
    register_file #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .REG_COUNT(REG_COUNT)
    ) regFile (
        .clk(clk),
        .WE3(s_RegWrite),
        .WD3(s_Result),
        .A1(s_Instr[19:15]),
        .A2(s_Instr[24:20]),
        .A3(s_Instr_ctrl_memwb),
        .RD1(s_RD1_reg),
        .RD2(s_RD2_reg)
    );

    // regfile outputs -> id/ex
    register #(.N(DATA_WIDTH)) reg_regFileA_IDEX (
        .clk(clk),
        .rst(rst),
        .d(s_RD1_reg),
        .q(s_SrcA)
    );

    register #(.N(DATA_WIDTH)) reg_regFileB_IDEX (
        .clk(clk),
        .rst(rst),
        .d(s_RD2_reg),
        .q(s_WriteData)
    );

    // extend immediato
    extend ext1 (
        .Instr(s_Instr[31:7]),
        .ImmSrc(s_ImmSrc_reg),
        .ImmExt(s_ImmExt_reg)
    );

    register #(.N(DATA_WIDTH)) reg_IMM (
        .clk(clk),
        .rst(rst),
        .d(s_ImmExt_reg),
        .q(s_ImmExt)
    );

    // controlador
    control_unit ctrl1 (
        .PCSrc(s_PCSrc_reg),
        .ResultSrc(s_ResultSrc_reg),
        .MemWrite(s_MemWrite_reg),
        .ALUControl(s_ALUControl_reg),
        .ALUSrc(s_ALUSrc_reg),
        .ImmSrc(s_ImmSrc_reg),
        .RegWrite(s_RegWrite_reg),
        .op(s_Instr[6:0]),
        .funct3(s_Instr[14:12]),
        .funct7(s_Instr[30]),
        .Zero(s_Zero),
        .Jump(s_jumpFlag),
        .jumpAddress(s_jumpAddress),
        .Branch(s_branchFlag_ex)
    );

    // id/ex pipeline register (controle + campos)
    register #(.N(19)) reg_ctrl_IDEX (
        .clk(clk),
        .rst(rst),
        .d({
            s_PCSrc_reg,
            s_ResultSrc_reg,
            s_MemWrite_reg,
            s_ALUControl_reg,
            s_ALUSrc_reg,
            s_ImmSrc_reg,
            s_RegWrite_reg,
            s_Instr[11:7],
            s_branchFlag_ex,
            s_Instr[14:12]
        }),
        .q({
            s_PCSrc_reg_mem,
            s_ResultSrc_reg_mem,
            s_MemWrite_reg_mem,
            s_ALUControl_reg_mem,
            s_ALUSrc_reg_mem,
            s_ImmSrc_reg_mem,
            s_RegWrite_reg_mem,
            s_Instr_ctrl_idex,
            s_branchFlag,
            s_funct3_idex
        })
    );

    // mem/wb pipeline register (controle + rd)
    register #(.N(15)) reg_ctrl_MEMWB (
        .clk(clk),
        .rst(rst),
        .d({
            s_PCSrc_reg_mem,
            s_ResultSrc_reg_mem,
            s_MemWrite_reg_mem,
            s_ALUControl_reg_mem,
            s_ALUSrc_reg_mem,
            s_ImmSrc_reg_mem,
            s_RegWrite_reg_mem,
            s_Instr_ctrl_idex
        }),
        .q({
            s_PCSrc,
            s_ResultSrc,
            s_MemWrite,
            s_ALUControl,
            s_ALUSrc,
            s_ImmSrc,
            s_RegWrite,
            s_Instr_ctrl_memwb
        })
    );

    // mux e alu
    mux2_1 mux_alu (
        .in0(s_WriteData),
        .in1(s_ImmExt),
        .sel(s_ALUSrc_reg_mem),
        .d(s_SrcB)
    );

    alu alu1 (
        .SrcA(s_SrcA),
        .SrcB(s_SrcB),
        .ALUControl(s_ALUControl_reg_mem),
        .Zero(s_Zero),
        .ALUResult(s_ALUResult_reg)
    );

    register #(.N(DATA_WIDTH)) reg_alu_EX (
        .clk(clk),
        .rst(rst),
        .d(s_ALUResult_reg),
        .q(s_ALUResult)
    );

    adder somaTarget (
        .a(s_PC),
        .b(s_ImmExt),
        .cin(1'b0),
        .result(s_PC_Target),
        .cout()
    );

    // memória de dados little-endian
    memTopo32LittleEndian #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(4)
    ) dataMem (
        .clk(clk),
        .size(s_funct3_idex[1:0]),
        .addr(s_ALUResult_reg[3:0]),
        .din(s_WriteData),
        .sign_ext(s_funct3_idex[2]),
        .writeEnable(s_MemWrite_reg_mem),
        .dout(s_ReadData_reg)
    );

    register #(.N(DATA_WIDTH)) reg_DATA_MEMORY (
        .clk(clk),
        .rst(rst),
        .d(s_ReadData_reg),
        .q(s_ReadData)
    );

    // escolhe entre ALU e memória
    mux2_1 mux_ALU_MEM (
        .in0(s_ALUResult),
        .in1(s_ReadData),
        .sel(s_ResultSrc),
        .d(s_Result)
    );

endmodule
