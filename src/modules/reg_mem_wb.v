// module: reg_mem_wb.v
// Descrição: Registrador de pipeline do Estágio MEM para o WB.
module reg_mem_wb (
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire flush,

    // === Entradas (do Estágio MEM) ===
    // Sinais de Dados
    input  wire [31:0] ALUResult_in,
    input  wire [31:0] ReadData_in,
    input  wire [31:0] PCPlus4_in,
    input  wire [4:0]  Rd_in,
    // Sinais de Controle
    input  wire [1:0]  ResultSrc_in,
    input  wire        RegWrite_in,

    // === Saídas (para o Estágio WB) ===
    // Sinais de Dados
    output wire [31:0] ALUResult_out,
    output wire [31:0] ReadData_out,
    output wire [31:0] PCPlus4_out,
    output wire [4:0]  Rd_out,
    // Sinais de Controle
    output wire [1:0]  ResultSrc_out,
    output wire        RegWrite_out
);

    // --- Registradores de Dados ---
    register #(.N(32)) reg_ALUResult(.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ALUResult_in), .q(ALUResult_out));
    register #(.N(32)) reg_ReadData (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ReadData_in),  .q(ReadData_out));
    register #(.N(32)) reg_PCPlus4  (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(PCPlus4_in),  .q(PCPlus4_out));
    register #(.N(5))  reg_Rd       (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(Rd_in),       .q(Rd_out));

    // --- Registradores de Controle ---
    // (O flush zera o RegWrite, o que é seguro)
    register #(.N(2)) reg_ResultSrc(.clk(clk), .rst(rst), .en(en), .flush(flush), .d(ResultSrc_in), .q(ResultSrc_out));
    register #(.N(1)) reg_RegWrite (.clk(clk), .rst(rst), .en(en), .flush(flush), .d(RegWrite_in),  .q(RegWrite_out));

endmodule