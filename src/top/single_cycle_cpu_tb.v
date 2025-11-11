module single_cycle_cpu_tb();
    reg clk;
    reg rst;

    single_cycle_cpu dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        $readmemh("/home/marcosbarbosa/Documents/verilog/full-pipeline-5-stages/src/inputs/input.txt", dut.instMem.memory);
        $dumpfile("build/single_cycle_cpu_tb.vcd");
        $dumpvars(0, single_cycle_cpu_tb);
    end

    initial begin
        // dut.dataMem.mem_inst.mem_byte0.mem[0] = 8'h12;
        // dut.dataMem.mem_inst.mem_byte1.mem[0] = 8'h34;
        // dut.dataMem.mem_inst.mem_byte2.mem[0] = 8'h78;
        // dut.dataMem.mem_inst.mem_byte3.mem[0] = 8'h56;

        // dut.dataMem.mem_inst.mem_byte0.mem[1] = 8'hF0;
        // dut.dataMem.mem_inst.mem_byte1.mem[1] = 8'hDE;
        // dut.dataMem.mem_inst.mem_byte2.mem[1] = 8'hBC;
        // dut.dataMem.mem_inst.mem_byte3.mem[1] = 8'h9A;
    end

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;
    end

    initial begin
        $display("\nTeste da microarquitetura RISC-V Pipeline iniciado");
        #1000
        $display("\nTeste da microarquitetura RISC-V Pipeline encerrado");
        $finish;
    end
endmodule
