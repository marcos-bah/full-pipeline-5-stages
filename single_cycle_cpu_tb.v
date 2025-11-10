module single_cycle_cpu_tb;
    reg clk;
    reg reset;

    // Instanciação da Unidade sob Teste (UUT)
    // Usando o módulo que corrigimos (anteriormente 'single_cycle_cpu')
    single_cycle_cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Bloco de display principal - Imprime no final de cada ciclo (negedge)
    // Isso nos dá uma visão estável do que aconteceu no ciclo de posedge.
    always @(negedge clk) begin
        // Não imprima nada durante o reset
        if (!reset) begin
            $display("| %5dns | h%8h | h%8h | h%8h | h%8h |  %2d   | h%8h |   %1b   |      %1b      |",
                $time,
                uut.IF_ID_PC,           // (Estágio ID) O PC da instrução em ID
                uut.IF_ID_Instr,      // (Estágio ID) A instrução em ID
                uut.EX_MEM_ALUResult,   // (Estágio MEM) O resultado da ALU vindo de EX
                uut.MEM_ReadData,       // (Estágio MEM) O dado lido da memória
                uut.MEM_WB_rd,          // (Estágio WB) O registrador de destino
                uut.WBe_Rsult,          // (Estágio WB) O resultado final a ser escrito
                uut.MEM_WB_RegWrite,    // (Estágio WB) Sinal de habilitação de escrita
                uut.EX_MEM_BranchTaken  // (Estágio MEM) Decisão de branch (que afeta o IF)
            );
        end
    end


    // Bloco de inicialização e Geração de Clock
    initial begin
        // Configuração do VCD (dump de formas de onda)
        $dumpfile("single_cycle_cpu_tb.vcd");
        $dumpvars(0, uut);

        // Inicialização do Clock e Reset
        clk = 0;
        reset = 1;
        #10; // Mantém o reset por 10ns
        reset = 0;

        // ===== INICIALIZAÇÃO DA DMEM A PARTIR DO TESTBENCH =====
        // O caminho é: [instância da UUT].[instância da dmem].[array da memória]
        $display("Inicializando Data Memory (dmem)...");
        uut.dmem.memory[0] = 32'd0;
        uut.dmem.memory[1] = 32'd1;
        uut.dmem.memory[2] = 32'd2;
        uut.dmem.memory[3] = 32'd3;
        uut.dmem.memory[4] = 32'd4;
        uut.dmem.memory[5] = 32'd5;
        uut.dmem.memory[6] = 32'd6;
        uut.dmem.memory[7] = 32'd7;
        uut.dmem.memory[8] = 32'd8;
        uut.dmem.memory[9] = 32'd9;
        // ========================================================

        // Impressão do Cabeçalho da Tabela (deve corresponder ao $display acima)
        $display("Iniciando teste da microarquitetura RISC-V Pipeline...");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");
        $display("| Tempo |   PC (ID)  |  Instr (ID) | ALURes(MEM) | MemData(MEM)| WB_rd | WB_Data  | WB_WE | BrTaken(MEM)|");
        $display("-----------------------------------------------------------------------------------------------------------------------------------");

        // Duração da simulação
        #500; // 500ns = 50 ciclos de clock (clock de 10ns)
        $display("-----------------------------------------------------------------------------------------------------------------------------------");
        $display("Encerrando teste da microarquitetura RISC...");
        $finish;
    end

    // Geração de clock: Período de 10ns (100MHz)
    always #5 clk = ~clk;

endmodule