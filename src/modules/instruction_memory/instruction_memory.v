module instruction_memory(
    input wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] memory [0:1023];
    assign RD = memory[A[31:2]]; // word aligned

    integer i;
    initial begin
        // Initialize memory to zero
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end

        // // Atividade 02:
        // // start
        // memory[0] = 32'h00A00293; // addi t0, x0, 10
        // memory[1] = 32'h00000313; // addi t1, x0, 0
        // memory[2] = 32'h00000393; // addi t2, x0, 0

        // // loop
        // memory[3] = 32'h0003AE03; // lw  t3, 0(t2)
        // memory[4] = 32'h01C30333; // add t1, t1, t3
        // memory[5] = 32'h00438393; // addi t2, t2, 4
        // memory[6] = 32'hfff28293; // addi t0, t0, -1
        // memory[7] = 32'hFE5008E3; // beq x0, x5, -16

        // // end
        // memory[8] = 32'h00000013; // end: addi x0, x0, 0
        // memory[9]= 32'hfc000ee3; // beq x0, x0, start

        // Atividade 03:
        // start
        // memory[0] = 32'h00A00293; // addi t0, x0, 10
        // memory[1] = 32'h00000313; // addi t1, x0, 0
        // memory[2] = 32'h00000393; // addi t2, x0, 0

        // memory[3] = 32'h00000013; // nop
        // memory[4] = 32'h00000013; // nop
        // memory[5] = 32'h00000013; // nop
        // memory[6] = 32'h02028863; // beq x5, x0, 48
        // memory[7] = 32'h00000013; // nop

        // // loop
        // memory[8] = 32'h0003AE03; // lw  t3, 0(t2)
        // memory[9] = 32'h00000013; // nop
        // memory[10] = 32'h00000013; // nop
        // memory[11] = 32'h00000013; // nop
        // memory[12] = 32'h00000013; // nop
        // memory[13] = 32'h01C30333; // add t1, t1, t3
        // memory[14] = 32'h00438393; // addi t2, t2, 4
        // memory[15] = 32'hfff28293; // addi t0, t0, -1
        // memory[16] = 32'h00000013; // nop
        // memory[17] = 32'h00000013; // nop
        // memory[18] = 32'hfc0006e3; // beq x0, x0, -52
        

        // // end
        // memory[19] = 32'h00000013; // enop
        // memory[20]= 32'hfa000ae3; // beq x0, x0, -76

        // Atividade 03 (CORRIGIDA)
        // start
        memory[0] = 32'h00A00293; // addi t0, x0, 10
        memory[1] = 32'h00000313; // addi t1, x0, 0
        memory[2] = 32'h00000393; // addi t2, x0, 0

        memory[3] = 32'h00000013; // nop
        memory[4] = 32'h00000013; // nop
        memory[5] = 32'h00000013; // nop
        
        // loop: (PC=24)
        memory[6] = 32'h03F28C63; // beq x5, x0, 52 (CORRIGIDO: pular para end @ PC=76)
        memory[7] = 32'h00000013; // nop

        // loop body
        memory[8] = 32'h0003AE03; // lw  t3, 0(t2)
        memory[9] = 32'h00000013; // nop
        memory[10] = 32'h00000013; // nop
        memory[11] = 32'h00000013; // nop
        memory[12] = 32'h00000013; // nop
        memory[13] = 32'h01C30333; // add t1, t1, t3
        memory[14] = 32'h00438393; // addi t2, t2, 4
        memory[15] = 32'hfff28293; // addi t0, t0, -1
        memory[16] = 32'h00000013; // nop
        memory[17] = 32'h00000013; // nop
        
        // (PC=72)
        memory[18] = 32'hFD000E63; // beq x0, x0, -48 (CORRIGIDO: pular para loop @ PC=24)
        
        // end: (PC=76)
        memory[19] = 32'h00000013; // enop
        memory[20]= 32'hfa000ae3; // beq x0, x0, -76 (loop infinito em end)
    end

endmodule