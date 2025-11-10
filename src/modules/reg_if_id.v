// module: reg_if_id.v
// Descrição: Registrador de pipeline do Estágio IF para o ID.
//            Usa o módulo 'register.v' como bloco de construção.
module reg_if_id (
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire flush,

    // Entradas (do Estágio IF)
    input  wire [31:0] PC_in,
    input  wire [31:0] PCPlus4_in,
    input  wire [31:0] Instr_in,
    
    // Saídas (para o Estágio ID)
    output wire [31:0] PC_out,
    output wire [31:0] PCPlus4_out,
    output wire [31:0] Instr_out
);

    // Instancia um registrador de 32 bits para o PC
    register #(.N(32)) reg_PC (
        .clk(clk),
        .rst(rst),
        .en(en),
        .flush(flush),
        .d(PC_in),
        .q(PC_out)
    );

    // Instancia um registrador de 32 bits para o PCPlus4
    register #(.N(32)) reg_PCPlus4 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .flush(flush),
        .d(PCPlus4_in),
        .q(PCPlus4_out)
    );

    // Instancia um registrador de 32 bits para a Instrução
    register #(.N(32)) reg_Instr (
        .clk(clk),
        .rst(rst),
        .en(en),
        .flush(flush),
        .d(Instr_in),
        .q(Instr_out)
    );

endmodule