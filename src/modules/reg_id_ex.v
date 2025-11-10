// module: reg_id_ex.v
// Descrição: Registrador de pipeline do Estágio ID para o EX.
//            Usa o módulo 'register.v' para cada sinal.
module reg_id_ex (
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire flush,

    // === Entradas (do Estágio ID) ===
    // Sinais de Dados
    input  wire [31:0] PC_in,
    input  wire [31:0] PCPlus4_in,
    input  wire [31:0] SrcA_in,       // RF_RD1
    input  wire [31:0] SrcB_in,       // RF_RD2
    input  wire [31:0] ImmExt_in,
    input  wire [4:0]  Rd_in,
    input  wire [2:0]  Funct3_in,
    input  wire        Funct7_5_in,
    // Sinais de Controle
    input  wire [1:0]  ALUOp_in,
    input  wire [1:0]  ResultSrc_in,
    input  wire        ALUSrc_in,
    input  wire        MemWrite_in,
    input  wire        RegWrite_in,
    input  wire        Branch_in,

    // === Saídas (para o Estágio EX) ===
    // Sinais de Dados
    output wire [31:0] PC_out,
    output wire [31:0] PCPlus4_out,
    output wire [31:0] SrcA_out,
    output wire [31:0] SrcB_out,
    output wire [31:0] ImmExt_out,
    output wire [4:0]  Rd_out,
    output wire [2:0]  Funct3_out,
    output wire        Funct7_5_out,
    // Sinais de Controle
    output wire [1:0]  ALUOp_out,
    output wire [1:0]  ResultSrc_out,
    output wire        ALUSrc_out,
    output wire        MemWrite_out,
    output wire        RegWrite_out,
    output wire        Branch_out
);

    // --- Registradores de Dados ---
    register #(.N(32)) reg_PC      (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(PC_in),       .q(PC_out));
    register #(.N(32)) reg_PCPlus4 (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(PCPlus4_in),  .q(PCPlus4_out));
    register #(.N(32)) reg_SrcA    (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(SrcA_in),      .q(SrcA_out));
    register #(.N(32)) reg_SrcB    (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(SrcB_in),      .q(SrcB_out));
    register #(.N(32)) reg_ImmExt  (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ImmExt_in),   .q(ImmExt_out));
    register #(.N(5))  reg_Rd      (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(Rd_in),       .q(Rd_out));
    register #(.N(3))  reg_Funct3  (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(Funct3_in),   .q(Funct3_out));
    register #(.N(1))  reg_Funct7_5(.clk(clk), .rst(rst), .en(en), .flush(flush), .d(Funct7_5_in), .q(Funct7_5_out));

    // --- Registradores de Controle ---
    // (O flush zera todos os sinais de controle, o que é seguro)
    register #(.N(2)) reg_ALUOp     (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ALUOp_in),     .q(ALUOp_out));
    register #(.N(2)) reg_ResultSrc (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ResultSrc_in), .q(ResultSrc_out));
    register #(.N(1)) reg_ALUSrc    (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ALUSrc_in),    .q(ALUSrc_out));
    register #(.N(1)) reg_MemWrite  (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(MemWrite_in),  .q(MemWrite_out));
    register #(.N(1)) reg_RegWrite  (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(RegWrite_in),  .q(RegWrite_out));
    register #(.N(1)) reg_Branch    (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(Branch_in),    .q(Branch_out));

endmodule