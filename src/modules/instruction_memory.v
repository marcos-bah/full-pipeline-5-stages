module instruction_memory(
    input wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] memory [1023:0];
    assign RD = memory[A[31:2]]; // word aligned

    integer i;
    initial begin
        // Initialize memory to zero
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end


        // memory[0] = 32'h00300293; // addi x5, x0, 3     -> x5 = 3
        // memory[1] = 32'h0004A303; // lw   x6, 0(x9)     -> x6 = Mem[x9 + 0]
        // memory[2] = 32'h00530333; // add  x6, x6, x5    -> x6 = x6 + x5
        // memory[3] = 32'h0064A023; // sw   x6, 0(x9)     -> Mem[x9 + 0] = x6
        // memory[4] = 32'hFE001AE3; // beq  x0, x0, L0    -> if (x0 == 0) PC = PC + offset (loop para L0)

        // Programa: Soma das 10 primeiras posições da memória (endereços 0–9)

        // start
        memory[0] = 32'h00A00293; // addi t0, x0, 10
        memory[1] = 32'h00000313; // addi t1, x0, 0
        memory[2] = 32'h00000393; // addi t2, x0, 0

        // loop
        memory[3] = 32'h28028A63; // beq t0, x0, end
        memory[4] = 32'h000E2383; // lw  t3, 0(t2)
        memory[5] = 32'h01C30333; // add t1, t1, t3
        memory[6] = 32'h00438393; // addi t2, t2, 4
        memory[7] = 32'hfff28293; // addi t0, t0, -1
        memory[8] = 32'hfe0006e3; // beq x0, x0, loop

        // end
        memory[9] = 32'h00000013; // end: addi x0, x0, 0
        memory[10]= 32'hfc000ee3; // beq x0, x0, start

        // //start
        // 0x00A00293; // addi t0, x0, 10
        // 0x00000313; // addi t1, x0, 0
        // 0x00000393; // addi t2, x0, 0

        // //loop
        // 0x28028A63; // beq t0, x0, end (20 offset)
        // 0x000E2383; // lw  t3, 0(t2)
        // 0x01C30333; // add t1, t1, t3
        // 0x00438393; // addi t2, t2, 4
        // 0xfff28293; // addi t0, t0, -1
        // 0xfe0006e3; // beq x0, x0, loop (-20 offset)

        // //end
        // 0x00000013; // addi x0, x0, 0
        // 0xfc000ee3; // beq x0, x0, start (-36 offset)

    end

endmodule