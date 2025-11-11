module top_tb_ativ_5();
    reg CLK;
    reg rst;

    top_ativ_5 dut(
        .CLK(CLK),
        .rst(rst)
    );

    initial begin
        $readmemh("/home/aluno/cidigital/aula_14_23_pipe_risc_5/pipe_5_RISC/instruction_memory/data_5.txt", dut.instMem.rom);
    end

    initial begin
        dut.dataMem.mem_inst.mem_byte0.mem[0] = 8'h12;
        dut.dataMem.mem_inst.mem_byte1.mem[0] = 8'h34;
        dut.dataMem.mem_inst.mem_byte2.mem[0] = 8'h78;
        dut.dataMem.mem_inst.mem_byte3.mem[0] = 8'h56;

        dut.dataMem.mem_inst.mem_byte0.mem[1] = 8'hF0;
        dut.dataMem.mem_inst.mem_byte1.mem[1] = 8'hDE;
        dut.dataMem.mem_inst.mem_byte2.mem[1] = 8'hBC;
        dut.dataMem.mem_inst.mem_byte3.mem[1] = 8'h9A;
    end

    initial   CLK = 1'b0;
    always #5 CLK = ~CLK;

    initial rst = 1'b1;
    initial #10 rst = 1'b0;

    initial begin
        $display("Iniciando teste da microarquitetura RISC-V Pipeline...");
        #1000
        $display("Encerrando teste da microarquitetura RISC...");
        $stop;
    end

endmodule
